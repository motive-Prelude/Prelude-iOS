//
//  CloudKitManager.swift
//  Junction
//
//  Created by 송지혁 on 10/12/24.
//

import Combine
import CloudKit
import UIKit

class CloudKitManager {
    static let shared = CloudKitManager()
    let database = CKContainer.default().privateCloudDatabase
    let cloudKitNotificationSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupCloudKitSubscription()
        listenCloudkitNotification()
    }
    
    func save(record: CKRecord) async throws {
        do {
            try await database.save(record)
        } catch {
            
        }
    }
    
    private func setupCloudKitSubscription() {
        let subscription = CKQuerySubscription(recordType: "UserInfo",
                                               predicate: NSPredicate(value: true),
                                               subscriptionID: "UserInfoSubscriptionID",
                                               options: [.firesOnRecordUpdate, .firesOnRecordCreation, .firesOnRecordDeletion])
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { subscription, error in
            if let error = error {
                print("Failed to create subscription: \(error)")
            } else {
                print("Subscription created: \(String(describing: subscription))")
            }
        }
    }
    
    private func listenCloudkitNotification() {
        NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)
            .compactMap { notification -> [AnyHashable: Any]? in
                notification.userInfo
            }
            .compactMap { userInfo -> CKQueryNotification? in
                CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
            }
            .sink { ckNotification in
                if let recordID = ckNotification.recordID {
                    self.cloudKitNotificationSubject.send()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetch(recordString: String) async -> CKRecord? {
        do {
            let recordID = CKRecord.ID(recordName: recordString)
            let record = try await database.record(for: recordID)
            return record
        } catch {  }
        
        return nil
    }
    
    func update<T>(record: CKRecord, type: T.Type) async {
        do {
            try await database.save(record)
        }
        catch let error as CKError {
            switch error.code {
                case .serverRecordChanged:
                    if let serverRecord = error.serverRecord { await handleUpdate(serverRecord: serverRecord, type: type) }
                    
                default: print(error)
            }
        } catch { print(error) }
        
        print("끝")
    }
    
    private func handleUpdate<T>(serverRecord: CKRecord, type: T.Type) async {
        if T.self == UserInfo.self {
            var newRecord = serverRecord
            newRecord["remainingTimes"]! = newRecord["remainingTimes"]! - 1
            await update(record: newRecord, type: UserInfo.self)
        } else if T.self == HealthInfo.self { await update(record: serverRecord, type: HealthInfo.self) }
        else { print("Unknown Type") }
        
    }
}
