//
//  HealthInfo.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

struct HealthInfo: Equatable, Hashable, Codable {
    var pregnantWeek: PregnantWeek
    var height: String
    var weight: String
    var bloodPressure: BloodPresure
    var diabetes: Diabetes
    
    var bmi: Double {
        return Double(weight)! / Double(height)! * Double(height)!
    }
}
