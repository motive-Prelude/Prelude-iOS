//
//  HealthCheckViewModel.swift
//  Junction
//
//  Created by 송지혁 on 10/12/24.
//

import CloudKit
import Foundation

class HealthCheckViewModel: ObservableObject {
    
    private let cloudkitManager: CloudKitManager
    private let swiftDataManager: SwiftDataManager
    
    init(cloudkitManager: CloudKitManager = CloudKitManager.shared, swiftDataManager: SwiftDataManager = SwiftDataManager.shared) {
        self.cloudkitManager = cloudkitManager
        self.swiftDataManager = swiftDataManager
    }
    
    func submit(healthInfo: HealthInfo) async {
        let result = await cloudkitManager.fetch(recordString: "UserInfo")
        
        if let record = result {
            guard let userInfo = UserInfo(from: record, healthInfo: healthInfo) else { return }
            swiftDataManager.saveData(userInfo)
        } else {
            let newUserInfo = UserInfo(remainingTimes: 0, healthInfo: healthInfo)
            swiftDataManager.saveData(newUserInfo)
        }
    }
    
    
    
    
}
