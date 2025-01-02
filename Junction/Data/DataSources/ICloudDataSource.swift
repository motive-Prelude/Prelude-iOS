//
//  CloudKitManager.swift
//  Junction
//
//  Created by 송지혁 on 10/12/24.
//

import Combine
import CloudKit
import UIKit

class ICloudDataSource {
    static let shared = ICloudDataSource()
    private let database = CKContainer.default().privateCloudDatabase
    private let zoneID = CKRecordZone.ID(zoneName: "prelude.zone",
                                         ownerName: CKCurrentUserDefaultName)
    private let zone: CKRecordZone
    let cloudKitNotificationSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.zone = CKRecordZone(zoneID: zoneID)
        setupCustomZone()
        setupCloudKitSubscription()
        
    }
    
    func save(record: CKRecord) async throws {
        do {
            try await database.save(record)
            print("저장 완료!")
        } catch {
            throw error
        }
    }
    
    private func setupCustomZone() {
        database.save(zone) { savedZone, error in
            if let error = error as? CKError {
                print("Custom Zone 이미 존재함: \(error.localizedDescription)")
            } else if let error = error {
                print("Custom Zone 생성 실패: \(error.localizedDescription)")
            } else {
                print("Custom Zone 생성 성공!")
            }
        }
    }
    
    private func setupCloudKitSubscription() {
        let subscriptionID = "UserInfoSubscriptionID"
        let subscription = CKRecordZoneSubscription(zoneID: zoneID, subscriptionID: subscriptionID)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { savedSubscription, error in
            if let error = error { print(error) }
            else { print(subscriptionID) }
        }
    }
    
    func processNotification(userInfo: [AnyHashable: Any]) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        if let subscriptionID = notification?.subscriptionID, subscriptionID == "UserInfoSubscriptionID" {
            cloudKitNotificationSubject.send()
        }
    }
    
    func fetch(userID: String) async -> CKRecord? {
        do {
            let recordID = CKRecord.ID(recordName: userID, zoneID: zoneID)
            let record = try await database.record(for: recordID)
            return record
        } catch { print(error) }
        
        return nil
    }
}
