//
//  UserRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Combine
import CloudKit

enum RepositoryError: Error {
    case cloudDataNotFound
    case localDataNotFound
    case dataParsingError
    case unknownError
}

class UserRepository {
    private let swiftDataSource: SwiftDataSource
    private let iCloudDataSource: ICloudDataSource
    private let firestoreDataSource: FirestoreDataSource<UserInfo>
    private var cancellables = Set<AnyCancellable>()
    let iCloudChangeSubject = PassthroughSubject<Void, Never>()
    
    
    init(swiftDataSource: SwiftDataSource = .shared,
         iCloudDataSource: ICloudDataSource = .shared,
         firestoreDataSource: FirestoreDataSource<UserInfo>) {
        self.swiftDataSource = swiftDataSource
        self.iCloudDataSource = iCloudDataSource
        self.firestoreDataSource = firestoreDataSource
        
        observeICloudChanges()
    }
    
    func create(user: UserInfo) async throws {
        do {
            try await firestoreDataSource.create(collection: "User", data: user)
            let record = user.toCKRecord()
            try await iCloudDataSource.save(record: record)
            swiftDataSource.saveData(user)
        } catch { print(error) }
    }
    
    func fetch(userID: String) async throws -> UserInfo {
        do {
            guard let user = await firestoreDataSource.fetch(collection: "User", documentID: userID) else { throw RepositoryError.unknownError }
            try await iCloudDataSource.save(record: user.toCKRecord())
            swiftDataSource.saveData(user)
                
                
                return user
            /*else {
                let newUserInfo = UserInfo(id: userID, remainingTimes: 0, healthInfo: nil)
                try await firestoreDataSource.create(collection: "User", data: newUserInfo)
                swiftDataSource.saveData(newUserInfo)
                try await iCloudDataSource.save(record: newUserInfo.toCKRecord())
                
                return newUserInfo
            }*/
        } catch let error as CKError {
            if error.code == .serverRecordChanged, let iCloudRecord = error.serverRecord {
                guard let serverInfo = await firestoreDataSource.fetch(collection: "User", documentID: userID) else { throw RepositoryError.unknownError }
                guard let iCloudDate = iCloudRecord["lastModified"] as? Date else { throw RepositoryError.unknownError }
                if serverInfo.lastModified > iCloudDate {
                    iCloudRecord["healthInfo"] = serverInfo.healthInfo as? CKRecordValue
                    iCloudRecord["remainingTimes"] = serverInfo.remainingTimes
                    iCloudRecord["lastModified"] = serverInfo.lastModified
                }
                
                try await iCloudDataSource.save(record: iCloudRecord)
                guard let iCloudInfo = UserInfo(from: iCloudRecord) else { throw RepositoryError.unknownError }
                swiftDataSource.saveData(iCloudInfo)
                return iCloudInfo
            }
            
            throw error
        }
    }
    
    func update(user: UserInfo) async throws {
        do {
            try await firestoreDataSource.update(collection: "User", data: user)
            try await iCloudDataSource.save(record: user.toCKRecord())
            swiftDataSource.saveData(user)
            
        } catch { print(error) }
    }
    
    func update(userID: String, field: [String: Any]) async throws -> UserInfo {
        do {
            try await firestoreDataSource.update(collection: "User", documentID: userID, fields: field)
            let newUserInfo = try await self.fetch(userID: userID)
            
            return newUserInfo
        } catch {
            throw error
        }
    }
    
    func delete(userID: String) {
        firestoreDataSource.delete(collection: "User", documentID: userID)
        try? swiftDataSource.removeAll()
    }
    
    private func observeICloudChanges() {
        iCloudDataSource.cloudKitNotificationSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.iCloudChangeSubject.send()
            }
            .store(in: &cancellables)
    }
    
    func syncFromICloud(userID: String) async throws -> UserInfo {
        guard let record = await iCloudDataSource.fetch(userID: userID) else { throw RepositoryError.unknownError }
        guard let userInfo = UserInfo(from: record) else { throw RepositoryError.unknownError }
        swiftDataSource.saveData(userInfo)
        return userInfo
    }
}
