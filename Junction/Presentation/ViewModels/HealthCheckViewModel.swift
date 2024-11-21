//
//  HealthCheckViewModel.swift
//  Junction
//
//  Created by 송지혁 on 10/12/24.
//

import CloudKit
import Foundation

class HealthCheckViewModel: ObservableObject {
    
    private let userStore: UserStore
    private let cloudkitManager: CloudKitManager
    private let swiftDataManager: SwiftDataManager
    
    init(cloudkitManager: CloudKitManager = CloudKitManager.shared, swiftDataManager: SwiftDataManager = SwiftDataManager.shared, userStore: UserStore = .shared) {
        self.cloudkitManager = cloudkitManager
        self.swiftDataManager = swiftDataManager
        self.userStore = userStore
    }
    
    func submit(healthInfo: HealthInfo) async {
        let result = await cloudkitManager.fetch(recordString: "UserInfo")
            
        if let record = result {
            guard let userInfo = UserInfo(from: record, healthInfo: healthInfo) else { return }
            swiftDataManager.saveData(userInfo)
            await cloudkitManager.update(record: userInfo.toCKRecord(), type: UserInfo.self)
            await cloudkitManager.update(record: healthInfo.toCKRecord(), type: HealthInfo.self)
        } else {
            let newUserInfo = UserInfo(remainingTimes: 0, healthInfo: healthInfo)
            swiftDataManager.saveData(newUserInfo)
            try? await cloudkitManager.save(record: newUserInfo.toCKRecord())
            try? await cloudkitManager.save(record: healthInfo.toCKRecord())
        }
    }
    
}
