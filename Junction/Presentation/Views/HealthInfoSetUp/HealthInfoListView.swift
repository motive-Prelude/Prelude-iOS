//
//  HealthInfoListView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import SwiftUI

struct HealthInfoListView: View {
    let healthInfo: HealthInfo
    let mode: ListItemType
    var onItemTap: ((PartialKeyPath<HealthInfo>) -> Void)?
    
    var gestationWeekData: String { healthInfo.gestationalWeek.rawValue }
    var heightData: String {
        switch healthInfo.lastHeightUnit {
            case .centimeter:
                return String(Int(healthInfo.height)) + healthInfo.lastHeightUnit.symbol
            case .feet, .inch:
                let (feet, inch) = healthInfo.height.convertCmToFeetAndInches()
                return String(Int(feet)) + "ft " + String(Int(inch)) + "in"
        }
    }
    
    var weightData: String {
        let unit = healthInfo.lastWeightUnit
        let weight = healthInfo.weight
        return String(Int(unit.fromBaseUnit(weight))) + unit.symbol
        
    }
    var bloodPressureData: String { healthInfo.bloodPressure.rawValue }
    var diabetesData: String { healthInfo.diabetes.rawValue }
    var restrictionsData: String {
        let restrictions = healthInfo.restrictions.map { $0.rawValue }.joined(separator: ", ")
        return restrictions.isEmpty ? "None" : restrictions
    }
    
    var body: some View {
        VStack {
            PLListItem(title: "Gestational Week", supportingText: gestationWeekData, mode) { onItemTap?(\.gestationalWeek) }
            PLListItem(title: "Height, Weight", supportingText: heightData + ", " + weightData, mode) { onItemTap?(\.height) }
            PLListItem(title: "Blood Pressure", supportingText: bloodPressureData, mode) { onItemTap?(\.bloodPressure) }
            PLListItem(title: "Diabetes", supportingText: diabetesData, mode) { onItemTap?(\.diabetes) }
            PLListItem(title: "Restrictions", supportingText: restrictionsData, mode) { onItemTap?(\.restrictions) }
        }
    }
}
