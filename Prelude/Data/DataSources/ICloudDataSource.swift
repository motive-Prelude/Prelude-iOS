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
        Task { try? await setupCustomZone() }
        Task { try? await setupCloudKitSubscription() }
        
    }
    
    func save(record: CKRecord) async throws {
        do {
            try await database.save(record)
        } catch let error as CKError { throw error }
    }
    
    func save(user: UserInfo) async throws(DataSourceError) {
        do {
            let record = user.toCKRecord()
            try await save(record: record)
        } catch let error as CKError where error.code == .serverRecordChanged {
            guard let iCloudRecord = error.serverRecord else { throw .unknown }
            let _ = try await mergeAndSave(user: user, iCloudRecord: iCloudRecord)
            
        } catch { throw .unknown }
    }
    
    private func setupCustomZone() async throws(DataSourceError) {
        do { try await database.save(zone) }
        catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    private func setupCloudKitSubscription() async throws(DataSourceError) {
        let subscriptionID = "UserInfoSubscriptionID"
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
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        if let subscriptionID = notification?.subscriptionID, subscriptionID == "UserInfoSubscriptionID" {
            cloudKitNotificationSubject.send()
        }
    }
    
    func fetch(userID: String) async throws(DataSourceError) -> CKRecord? {
        do {
            let recordID = CKRecord.ID(recordName: userID, zoneID: zoneID)
            let record = try await database.record(for: recordID)
            return record
        } catch let error as CKError {
            throw parseError(error)
        } catch { throw .unknown }
    }
    
    @discardableResult
    func mergeAndSave(user: UserInfo, iCloudRecord: CKRecord) async throws(DataSourceError) -> UserInfo {
        guard let iCloudDate = iCloudRecord["lastModified"] as? Date else { throw DataSourceError.unknown }
        if user.lastModified > iCloudDate {
            iCloudRecord["remainingTimes"] = user.remainingTimes
            iCloudRecord["lastModified"] = user.lastModified
            iCloudRecord["didAgreeToTermsAndConditions"] = user.didAgreeToTermsAndConditions
            iCloudRecord["didReceiveGift"] = user.didReceiveGift
            
            if let healthInfo = user.healthInfo {
                do {
                    let jsonData = try JSONEncoder().encode(healthInfo)
                    iCloudRecord["healthInfo"] = jsonData as CKRecordValue
                } catch { throw .unknown }
            }
            
            do { try await save(record: iCloudRecord) }
            catch { throw .unknown }
        }
        
        guard let mergedUserInfo = UserInfo(from: iCloudRecord) else { throw DataSourceError.unknown }
        return mergedUserInfo
    }
    
    private func parseError(_ error: CKError) -> DataSourceError {
        switch error.code {
            case .networkFailure, .networkUnavailable: return .networkUnavailable
            case .accountTemporarilyUnavailable: return .cancelled
            case .notAuthenticated: return .unauthenticated
            case .permissionFailure: return .permissionDenied
            case .quotaExceeded: return .quotaExceeded
            case .serverRecordChanged: return .conflict
            case .requestRateLimited: return .tooManyRequests
            default: return .unknown
        }
    }
}
