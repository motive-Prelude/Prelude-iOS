//
//  HealthInfo.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import CloudKit
import SwiftData

@Model
final class HealthInfo {
    var id: String
    var pregnantWeek: PregnantWeek = PregnantWeek.early
    var height: String = ""
    var weight: String = ""
    var bloodPressure: BloodPresure = BloodPresure.normal
    var diabetes: Diabetes = Diabetes.notAffected
    
    var bmi: Double {
        guard let weightValue = Double(weight), let heightValue = Double(height) else { return 0.0 }
        return weightValue / heightValue * heightValue
    }
    
    init(id: String = "HealthInfo", pregnantWeek: PregnantWeek, height: String, weight: String, bloodPressure: BloodPresure, diabetes: Diabetes) {
        self.id = id
        self.pregnantWeek = pregnantWeek
        self.height = height
        self.weight = weight
        self.bloodPressure = bloodPressure
        self.diabetes = diabetes
    }
}

extension HealthInfo: Convertible {
    func toCKRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: self.id)
        let record = CKRecord(recordType: "HealthInfo", recordID: recordID)
        
        record["pregnantWeek"] = self.pregnantWeek.rawValue as CKRecordValue
        record["height"] = self.height as CKRecordValue
        record["weight"] = self.weight as CKRecordValue
        record["bloodPressure"] = self.bloodPressure.rawValue as CKRecordValue
        record["diabetes"] = self.diabetes.rawValue as CKRecordValue
        
        return record
    }
    
    convenience init?(from record: CKRecord) {
        let id = record.recordID.recordName
        guard let pregnantWeekRaw = record["pregnantWeek"] as? String,
              let pregnantWeek = PregnantWeek(rawValue: pregnantWeekRaw),
              let height = record["height"] as? String,
              let weight = record["weight"] as? String,
              let bloodPressureRaw = record["bloodPressure"] as? String,
              let bloodPressure = BloodPresure(rawValue: bloodPressureRaw),
              let diabetesRaw = record["diabetes"] as? String,
              let diabetes = Diabetes(rawValue: diabetesRaw)
        else { return nil }
        
        self.init(id: id, pregnantWeek: pregnantWeek, height: height, weight: weight, bloodPressure: bloodPressure, diabetes: diabetes)
    }
}
