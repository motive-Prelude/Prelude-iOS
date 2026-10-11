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
    let cloudKitNotificationSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let subscriptionID = "UserInfoSubscriptionID"
    
    private init() {
        self.zone = CKRecordZone(zoneID: zoneID)
        Task { try? await setupCustomZone() }
        Task { try? await setupCloudKitSubscription() }
        
    }
    
    func save<T: CloudKitConvertible>(_ entity: T) async throws(DataSourceError) {
        do {
            let record = entity.toCKRecord()
            try await database.save(record)
        } catch let error as CKError where error.code == .serverRecordChanged {
            guard let serverRecord = error.serverRecord else { throw .unknown }
            let id = serverRecord.recordID.recordName
            
            throw .conflict(id: id)
            
        }
        catch { throw .unknown }
    }
    
    func save(_ ckRecord: CKRecord) async throws(DataSourceError) {
        do {
            try await database.save(ckRecord)
        } catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    func fetch<T: CloudKitConvertible>(id: String) async throws(DataSourceError) -> T? {
        let recordID = CKRecord.ID(recordName: id, zoneID: zoneID)
        
        do {
            let record = try await database.record(for: recordID)
            return T(from: record)
        } catch let error as CKError { throw parseError(error) }
        catch { throw .unknown }
    }
    
    func fetch(id: String) async throws(DataSourceError) -> CKRecord {
        let recordID = CKRecord.ID(recordName: id, zoneID: zoneID)
        
        do {
            let record = try await database.record(for: recordID)
            return record
        } catch let error as CKError { throw parseError(error) }
        catch { throw .unknown }
    }
    
    func delete(id: String) async throws(DataSourceError) {
        let recordID = CKRecord.ID(recordName: id, zoneID: zoneID)
        
        do {
            try await database.deleteRecord(withID: recordID)
        } catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    
    private func setupCustomZone() async throws(DataSourceError) {
        do { try await database.save(zone) }
        catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    private func setupCloudKitSubscription() async throws(DataSourceError) {
        let subscription = CKRecordZoneSubscription(zoneID: zoneID, subscriptionID: subscriptionID)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        do { try await database.save(subscription) }
        catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    func processNotification(userInfo: [AnyHashable: Any]) {
        guard let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) as? CKQueryNotification,
              let recordID = notification.recordID,
              let subscriptionID = notification.subscriptionID,
              subscriptionID == self.subscriptionID else {
            return
        }
        
        let recordName = recordID.recordName
        cloudKitNotificationSubject.send(recordName)
    }
    
    private func parseError(_ error: CKError) -> DataSourceError {
        switch error.code {
            case .networkFailure, .networkUnavailable: return .networkUnavailable
            case .accountTemporarilyUnavailable: return .cancelled
            case .notAuthenticated: return .unauthenticated
            case .permissionFailure: return .permissionDenied
            case .quotaExceeded: return .quotaExceeded
            case .requestRateLimited: return .tooManyRequests
            default: return .unknown
        }
    }
}
