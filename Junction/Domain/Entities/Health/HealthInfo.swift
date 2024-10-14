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

    }
}
