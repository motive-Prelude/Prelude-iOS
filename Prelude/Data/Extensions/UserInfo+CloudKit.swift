//
//  UserInfo+CloudKit.swift
//  Prelude
//
//  Created by 송지혁 on 4/7/25.
//

import CloudKit

// MARK: 반드시 Data Layer에 속해있어야 클린 아키텍처 의존성 규칙을 위반하지 않습니다
extension UserInfo: CloudKitConvertible {
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
