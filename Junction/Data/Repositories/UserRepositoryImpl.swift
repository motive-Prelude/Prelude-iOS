//
//  UserRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

enum RepositoryError: Error {
    case cloudDataNotFound
    case localDataNotFound
    case dataParsingError
    case unknownError
}

class UserRepositoryImpl {
    private let cloudkitManager: CloudKitManager
    private let swiftDataManager: SwiftDataManager
    
    init(cloudkitManager: CloudKitManager = .shared, swiftDataManager: SwiftDataManager = .shared) {
        self.cloudkitManager = cloudkitManager
        self.swiftDataManager = swiftDataManager
    }
    
    func fetchUserInfo() async throws(RepositoryError) -> UserInfo {
        let localUserInfo = swiftDataManager.fetchLatest(data: UserInfo.self)
        let cloudUserInfo = await fetchCloudUserInfo()
        
        if let userInfo = localUserInfo ?? cloudUserInfo {
            return userInfo
        }
        
        guard let local = localUserInfo, let cloud = cloudUserInfo else {
            throw RepositoryError.cloudDataNotFound
        }
        
        return mergeUserInfo(cloudInfo: cloud, localInfo: local)
        
        
    }
    
    private func fetchCloudUserInfo() async -> UserInfo? {
        guard
            let cloudUserInfoRecord = await cloudkitManager.fetch(recordString: "UserInfo"),
            let cloudHealthInfoRecord = await cloudkitManager.fetch(recordString: "HealthInfo"),
            let healthInfo = HealthInfo(from: cloudHealthInfoRecord)
        else {
            return nil
        }
        
        return UserInfo(from: cloudUserInfoRecord, healthInfo: healthInfo)
    }
    
    func updateUserInfo(newInfo: UserInfo) async {
        let record = newInfo.toCKRecord()
        guard let healthInfoRecord = newInfo.healthInfo?.toCKRecord() else { return }
        
        await cloudkitManager.update(record: record, type: UserInfo.self)
        await cloudkitManager.update(record: healthInfoRecord, type: HealthInfo.self)
        swiftDataManager.saveData(newInfo)
    }
    
    private func mergeUserInfo(cloudInfo: UserInfo, localInfo: UserInfo) -> UserInfo {
        if cloudInfo.lastModified > localInfo.lastModified {
            return cloudInfo
        }
        else if localInfo.lastModified > cloudInfo.lastModified {
            return localInfo
        }
        else {
            let mergedRemainingTimes = max(cloudInfo.remainingTimes, localInfo.remainingTimes)
            
            let mergedUserInfo = UserInfo(
                id: cloudInfo.id,
                remainingTimes: mergedRemainingTimes,
                healthInfo: localInfo.healthInfo ?? cloudInfo.healthInfo
            )
            
            return mergedUserInfo
        }
    }
}
