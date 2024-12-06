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
    var gestationalWeek: GestationalWeek = GestationalWeek.early
    var height: Double
    var weight: Double
    var lastHeightUnit: HeightUnit
    var lastWeightUnit: WeightUnit
    var bloodPressure: BloodPresure = BloodPresure.none
    var diabetes: Diabetes = Diabetes.none
    var restrictions: [Allergies] = []
    var bmi: Double { weight / (height * height * 0.0001) }
    
    init(id: String = "HealthInfo",
         gestationalWeek: GestationalWeek,
         height: Double,
         weight: Double,
         lastHeightUnit: HeightUnit,
         lastWeightUnit: WeightUnit,
         bloodPressure: BloodPresure,
         diabetes: Diabetes,
         restrictions: [Allergies]) {
        self.id = id
        self.gestationalWeek = gestationalWeek
        self.height = height
        self.weight = weight
        self.lastHeightUnit = lastHeightUnit
        self.lastWeightUnit = lastWeightUnit
        self.bloodPressure = bloodPressure
        self.diabetes = diabetes
        self.restrictions = restrictions
    }
}

extension HealthInfo: Convertible {
    func toCKRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: self.id)
        let record = CKRecord(recordType: "HealthInfo", recordID: recordID)
        
        record["pregnantWeek"] = self.gestationalWeek.rawValue as CKRecordValue
        record["height"] = self.height as CKRecordValue
        record["weight"] = self.weight as CKRecordValue
        record["lastHeightUnit"] = self.lastHeightUnit.rawValue
        record["lastWeightUnit"] = self.lastWeightUnit.rawValue
        record["bloodPressure"] = self.bloodPressure.rawValue as CKRecordValue
        record["diabetes"] = self.diabetes.rawValue as CKRecordValue
        record["restrictions"] = self.restrictions.map { $0.rawValue } as NSArray
        
        return record
    }
    
    convenience init?(from record: CKRecord) {
        let id = record.recordID.recordName
        guard let pregnantWeekRaw = record["pregnantWeek"] as? String,
              let pregnantWeek = GestationalWeek(rawValue: pregnantWeekRaw),
              let height = record["height"] as? Double,
              let weight = record["weight"] as? Double,
              let heightUnitString = record["lastHeightUnit"] as? String,
              let lastHeightUnit = HeightUnit(rawValue: heightUnitString),
              let weightUnitString = record["lastWeightUnit"] as? String,
              let lastWeightUnit = WeightUnit(rawValue: weightUnitString),
              let bloodPressureRaw = record["bloodPressure"] as? String,
              let bloodPressure = BloodPresure(rawValue: bloodPressureRaw),
              let diabetesRaw = record["diabetes"] as? String,
              let diabetes = Diabetes(rawValue: diabetesRaw),
              let restrictionsRaw = record["restrictions"] as? [String]
        else { return nil }
        
        let restrictions: [Allergies] = restrictionsRaw.compactMap { Allergies(rawValue: $0) }
        
        self.init(id: id,
                  gestationalWeek: pregnantWeek,
                  height: height,
                  weight: weight,
                  lastHeightUnit: lastHeightUnit,
                  lastWeightUnit: lastWeightUnit,
                  bloodPressure: bloodPressure,
                  diabetes: diabetes,
                  restrictions: restrictions)
    }
}
