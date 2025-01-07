//
//  HealthInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

enum Diabetes: String, Codable {
    case none = "None"
    case type1 = "Type 1"
    case type2 = "Type 2"
    case gestational = "Gestational"
    case noResponse = "No response"
    
    var localized: String {
        switch self {
            case .none: return Localization.Label.noneLabel
            case .type1: return Localization.Diabetes.type1Option
            case .type2: return Localization.Diabetes.type2Option
            case .gestational: return Localization.Diabetes.gestationalOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
}

enum BloodPressure: String, Codable {
    case none = "None"
    case hypotension = "Hypotension"
    case hypertension = "Hypertension"
    case noResponse = "No response"
    
    var localized: String {
        switch self {
            case .none: return Localization.Label.noneLabel
            case .hypotension: return Localization.BloodPressure.hypoTensionOption
            case .hypertension: return Localization.BloodPressure.hyperTensionOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
}

enum GestationalWeek: String, CaseIterable, Codable {
    case early = "1st trimester"
    case mid = "2nd trimester"
    case late = "3rd trimester"
    case postpartum = "Postpartum"
    case noResponse = "No response"
    
    static var allCases: [GestationalWeek] {
        return [.early, .mid, .late, .postpartum]
    }
    
    var localized: String {
        switch self {
            case .early: return Localization.GestationalWeek.firstTrimsterOption
            case .mid: return Localization.GestationalWeek.secondTrimsterOption
            case .late: return Localization.GestationalWeek.thirdTrimsterOption
            case .postpartum: return Localization.GestationalWeek.postpartumOption
            case .noResponse: return Localization.Label.noResponseLabel
        }
    }
    
    var weeks: String {
        let weekLocalized = Localization.Label.weekLabel
        
        switch self {
            case .early: return "1-13 \(weekLocalized)"
            case .mid: return "14-27 \(weekLocalized)"
            case .late: return "28-40 \(weekLocalized)"
            case .postpartum: return Localization.GestationalWeek.postpartumDescription
            default: return ""
        }
    }
}

enum Allergies: String, CaseIterable, Codable {
    case diary = "Diary"
    case eggs = "Eggs"
    case fish = "Fish"
    case shellfish = "Shellfish"
    case treeNuts = "Tree nuts"
    case peanuts = "Peanuts"
    case wheat = "Wheat"
    case soy = "Soy"
    case gluten = "Gluten"
    
    static var totalCount: Int { Allergies.allCases.count }
}

struct BasicInfoSetUpView: View {
    @Binding var gestationalWeek: GestationalWeek?
    @Binding var height: Height?
    @Binding var weight: Weight?
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            pregnantWeekInstruction
                .padding(.bottom, 16)
            GestationalWeekGrid(gestationalWeek: gestationalWeek) { week in gestationalWeek = week }
                .padding(.bottom, 44)
            
            heightAndWeightInstruction
                .padding(.bottom, 16)
            
            BmiTextFields(height: height, weight: weight) { height, weight in
                self.height = height
                self.weight = weight
            }
        }
    }
    
    private var pregnantWeekInstruction: some View {
        Text("How many weeks pregnant are you?")
            .textStyle(typographies.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var heightAndWeightInstruction: some View {
        Text("What is your height and Weight?")
            .textStyle(typographies.title1)
            .foregroundStyle(PLColor.neutral800)
    }
}

//#Preview {
//    @Previewable @State var pregnantWeek: GestationalWeek? = nil
//    @Previewable @State var heightValues: [HeightUnit: Double] = [:]
//    @Previewable @State var weightValues: [WeightUnit: Double] = [:]
//    
//    @Previewable @State var heightLeftSelected = true
//    @Previewable @State var weightLeftSelected = true
//    
//    BasicInfoSetUpView(gestationalWeek: $pregnantWeek,
//                       height: h)
//}
//
