//
//  UserInfo.swift
//  Junction
//
//  Created by 송지혁 on 10/9/24.
//

import CloudKit
import SwiftData
import Foundation

@Model
final class UserInfo {
    var id: String
    var remainingTimes: UInt = 0
    var healthInfo: HealthInfo?
    var lastModified: Date
    var didAgreeToTermsAndConditions: Bool
    var didReceiveGift: Bool
    
    init(id: String, remainingTimes: UInt, healthInfo: HealthInfo? = nil, lastModified: Date = Date(), didAgreeToTermsAndConditions: Bool = false, didReceiveGift: Bool = false) {
        self.id = id
        self.remainingTimes = remainingTimes
        self.healthInfo = healthInfo
        self.lastModified = lastModified
        self.didAgreeToTermsAndConditions = didAgreeToTermsAndConditions
        self.didReceiveGift = didReceiveGift
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.remainingTimes = try container.decode(UInt.self, forKey: .remainingTimes)
        self.healthInfo = try container.decodeIfPresent(HealthInfo.self, forKey: .healthInfo)
        self.lastModified = try container.decode(Date.self, forKey: .lastModified)
        self.didAgreeToTermsAndConditions = try container.decode(Bool.self, forKey: .didAgreeToTermsAndConditions)
        self.didReceiveGift = try container.decode(Bool.self, forKey: .didReceiveGift)
    }
}

// MARK: Class -> CKRecord
extension UserInfo: Convertible {
    func toCKRecord() -> CKRecord {
        let zoneID = CKRecordZone.ID(zoneName: "prelude.zone", ownerName: CKCurrentUserDefaultName)
        let recordID = CKRecord.ID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "UserInfo", recordID: recordID)
        record["remainingTimes"] = self.remainingTimes as CKRecordValue
        record["lastModified"] = self.lastModified as CKRecordValue
        record["didAgreeToTermsAndConditions"] = self.didAgreeToTermsAndConditions as CKRecordValue
        record["didReceiveGift"] = self.didReceiveGift as CKRecordValue
        
        if let healthInfo = healthInfo {
            do {
                let jsonData = try JSONEncoder().encode(healthInfo)
                record["healthInfo"] = jsonData as CKRecordValue
            } catch {
                print("Failed to encode healthInfo: \(error)")
            }
        }
        
        return record
    }
    
    convenience init?(from record: CKRecord) {
        guard let remainingTimes = record["remainingTimes"] as? UInt,
              let lastModified = record["lastModified"] as? Date,
        let didAgreeToTermsAndConditions = record["didAgreeToTermsAndConditions"] as? Bool,
        let didReceiveGift = record["didReceiveGift"] as? Bool
        else {
            return nil
        }
        let id = record.recordID.recordName
        
        self.init(id: id, remainingTimes: remainingTimes, lastModified: lastModified, didAgreeToTermsAndConditions: didAgreeToTermsAndConditions, didReceiveGift: didReceiveGift)
        
        if let healthInfoData = record["healthInfo"] as? Data {
            do {
                self.healthInfo = try JSONDecoder().decode(HealthInfo.self, from: healthInfoData)
            } catch {
                print("Failed to decode healthInfo: \(error)")
                self.healthInfo = nil
            }
        }
    }
}

// MARK: Codable
extension UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case id, remainingTimes, healthInfo, lastModified, didAgreeToTermsAndConditions, didReceiveGift
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(remainingTimes, forKey: .remainingTimes)
        try container.encode(healthInfo, forKey: .healthInfo)
        try container.encode(lastModified, forKey: .lastModified)
        try container.encode(didAgreeToTermsAndConditions, forKey: .didAgreeToTermsAndConditions)
        try container.encode(didReceiveGift, forKey: .didReceiveGift)
    }
}
