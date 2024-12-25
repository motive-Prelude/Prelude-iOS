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
    var bloodPressure: BloodPressure = BloodPressure.none
    var diabetes: Diabetes = Diabetes.none
    var restrictions: [Allergies] = []
    var bmi: Double { weight / (height * height * 0.0001) }
    
    init(id: String,
         gestationalWeek: GestationalWeek,
         height: Double,
         weight: Double,
         lastHeightUnit: HeightUnit,
         lastWeightUnit: WeightUnit,
         bloodPressure: BloodPressure,
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.gestationalWeek = try container.decode(GestationalWeek.self, forKey: .gestationalWeek)
        self.height = try container.decode(Double.self, forKey: .height)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.lastHeightUnit = try container.decode(HeightUnit.self, forKey: .lastHeightUnit)
        self.lastWeightUnit = try container.decode(WeightUnit.self, forKey: .lastWeightUnit)
        self.bloodPressure = try container.decode(BloodPressure.self, forKey: .bloodPressure)
        self.diabetes = try container.decode(Diabetes.self, forKey: .diabetes)
        self.restrictions = try container.decodeIfPresent([Allergies].self, forKey: .restrictions) ?? []
        
        
    }
}


// MARK: Class -> CKRecord
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
              let bloodPressure = BloodPressure(rawValue: bloodPressureRaw),
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

// MARK: Codable
extension HealthInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case id, gestationalWeek, height, weight, lastHeightUnit, lastWeightUnit, bloodPressure, diabetes, restrictions
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(gestationalWeek, forKey: .gestationalWeek)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(lastHeightUnit, forKey: .lastHeightUnit)
        try container.encode(lastWeightUnit, forKey: .lastWeightUnit)
        try container.encode(bloodPressure, forKey: .bloodPressure)
        try container.encode(diabetes, forKey: .diabetes)
        try container.encode(restrictions, forKey: .restrictions)
        
    }
}
