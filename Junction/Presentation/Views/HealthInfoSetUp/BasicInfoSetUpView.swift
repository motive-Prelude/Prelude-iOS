//
//  HealthInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import Collections
import SwiftUI

enum Diabetes: String, Codable {
    case none = "None"
    case type1 = "Type 1"
    case type2 = "Type 2"
    case gestational = "Gestational"
    case noResponse = "No response"
}

enum BloodPresure: String, Codable {
    case none = "None"
    case hypotension = "Hypotension"
    case hypertension = "Hypertension"
    case noResponse = "No response"
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
    
    
    var weeks: String {
        switch self {
            case .early: return "1-13 weeks"
            case .mid: return "14-27 weeks"
            case .late: return "28-40 weeks"
            case .postpartum: return "After childbirth"
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
    @Binding var heightValues: [HeightUnit: Double]
    @Binding var weightValues: [WeightUnit: Double]
    
    @Binding var heightLeftSelected: Bool
    @Binding var weightLeftSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            pregnantWeekInstruction
                .padding(.bottom, 16)
            pregnantWeekGrid
                .padding(.bottom, 44)
            
            heightAndWeightInstruction
                .padding(.bottom, 16)
            
            PLInputField(isLeftSelected: $heightLeftSelected,
                         value: $heightValues,
                         leftUnit: .centimeter,
                         rightUnit: .feet)
            .padding(.bottom, 8)
            
            PLInputField(isLeftSelected: $weightLeftSelected,
                         value: $weightValues,
                         leftUnit: .kilogram,
                         rightUnit: .pound)
        }
    }
    
    private var pregnantWeekInstruction: some View {
        Text("How many weeks pregnant are you?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var pregnantWeekGrid: some View {
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns) {
            ForEach(GestationalWeek.allCases, id: \.self) { week in
                PLFormButton(label: week.rawValue,
                             description: week.weeks,
                             isSelected: bindingForWeek(week),
                             contentType: .description,
                             mode: .stretch)
                .onTapGesture {
                    withAnimation {
                        gestationalWeek = (gestationalWeek == week) ? nil : week
                    }
                }
            }
        }
    }
    
    private var heightAndWeightInstruction: some View {
        Text("What is your height and Weight?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private func bindingForWeek(_ week: GestationalWeek) -> Binding<Bool> {
        Binding(
            get: { gestationalWeek == week },
            set: { isSelected in
                gestationalWeek = isSelected ? week : nil
            }
        )
    }
}

#Preview {
    @Previewable @State var pregnantWeek: GestationalWeek? = nil
    @Previewable @State var heightValues: [HeightUnit: Double] = [:]
    @Previewable @State var weightValues: [WeightUnit: Double] = [:]
    
    @Previewable @State var heightLeftSelected = true
    @Previewable @State var weightLeftSelected = true
    
    BasicInfoSetUpView(gestationalWeek: $pregnantWeek,
                       heightValues: $heightValues,
                       weightValues: $weightValues,
                       heightLeftSelected: $heightLeftSelected,
                       weightLeftSelected: $weightLeftSelected)
}

