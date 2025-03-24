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
    
    var gestationWeekData: String { healthInfo.gestationalWeek.localized }
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
    var bloodPressureData: String { healthInfo.bloodPressure.localized }
    var diabetesData: String { healthInfo.diabetes.localized }
    var restrictionsData: String {
        let restrictions = healthInfo.restrictions.map { $0.localized }.joined(separator: ", ")
        return restrictions.isEmpty ? Localization.Label.noneLabel : restrictions
    }
    
    var body: some View {
        VStack {
            PLListItem(title: Localization.HealthInfoOption.gestationalWeek, supportingText: gestationWeekData, mode) { onItemTap?(\.gestationalWeek) }
            PLListItem(title: Localization.HealthInfoOption.heightAndWeight, supportingText: heightData + ", " + weightData, mode) { onItemTap?(\.height) }
            PLListItem(title: Localization.HealthInfoOption.bloodPressure, supportingText: bloodPressureData, mode) { onItemTap?(\.bloodPressure) }
            PLListItem(title: Localization.HealthInfoOption.diabetes, supportingText: diabetesData, mode) { onItemTap?(\.diabetes) }
            PLListItem(title: Localization.HealthInfoOption.restrictions, supportingText: restrictionsData, mode) { onItemTap?(\.restrictions) }
        }
    }
}
