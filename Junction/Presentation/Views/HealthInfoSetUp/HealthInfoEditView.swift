//
//  HealthInfoConfirmationView.swift
//  Junction
//
//  Created by 송지혁 on 12/2/24.
//

import SwiftUI

struct HealthInfoEditView: View {
    let healthInfo: HealthInfo
    let mode: ListItemType
    
    @EnvironmentObject var navigationManager: NavigationManager
    
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
        InfoStepTemplate(backgroundColor: PLColor.neutral50) {
            headline
                .padding(.top, 100)
        } content: {
            healthInfoList
            Spacer()
        } buttons: { buttonGroup }
        .navigationBarBackButtonHidden()
    }
    
    private var headline: some View {
        VStack(spacing: 8) {
            Text("Is this correct?")
                .textStyle(.heading2)
                .foregroundStyle(PLColor.neutral800)
            
            Text("You can edit your health data anytime.")
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral600)
        }
    }
    
    private var healthInfoList: some View {
        VStack {
            PLListItem(title: "Gestational Week", supportingText: gestationWeekData, mode)
            PLListItem(title: "Height, Weight", supportingText: heightData + ", " + weightData, mode)
            PLListItem(title: "Blood Pressure", supportingText: bloodPressureData, mode)
            PLListItem(title: "Diabetes", supportingText: diabetesData, mode)
            PLListItem(title: "Restrictions", supportingText: restrictionsData, mode)
        }
    }
    
    private var buttonGroup: some View {
        HStack(spacing: 12) {
            PLActionButton(label: "Make changes",
                           type: .secondary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) { navigationManager.previous() }
            
            PLActionButton(label: "All good",
                           type: .primary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) {
                navigationManager.navigate(.main)
            }
        }
    }
}

#Preview {
    let healthInfo = HealthInfo(id: "",
                                gestationalWeek: .mid,
                                height: 123,
                                weight: 32,
                                lastHeightUnit: .centimeter,
                                lastWeightUnit: .kilogram,
                                bloodPressure: .hypotension,
                                diabetes: .type1,
                                restrictions: [.diary, .eggs, .fish, .shellfish, .treeNuts, .peanuts, .wheat, .soy, .gluten])
    
    HealthInfoEditView(healthInfo: healthInfo, mode: .passive)
        .environmentObject(NavigationManager())
}
