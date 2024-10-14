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
    var remainingTimes: Int = 0
    var healthInfo: HealthInfo?
    
    init(id: String = "UserInfo", remainingTimes: Int, healthInfo: HealthInfo? = nil) {
        self.id = id
        self.remainingTimes = remainingTimes
        self.healthInfo = healthInfo
    }
}

extension UserInfo: Convertible {
    func toCKRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: self.id)
        let record = CKRecord(recordType: "UserInfo", recordID: recordID)
        record["remainingTimes"] = self.remainingTimes as CKRecordValue
        
        if let healthInfo = healthInfo {
            let healthInfoRecord = healthInfo.toCKRecord()
            let reference = CKRecord.Reference(recordID: healthInfoRecord.recordID, action: .deleteSelf)
            record["healthInfo"] = reference
        }
        
        return record
    }
    
    convenience init?(from record: CKRecord, healthInfo: HealthInfo) {
        let id = record.recordID.recordName
        guard let remainingTimes = record["remainingTimes"] as? Int else { return nil }
        
        
        self.init(id: id, remainingTimes: remainingTimes, healthInfo: healthInfo)
    }
}
