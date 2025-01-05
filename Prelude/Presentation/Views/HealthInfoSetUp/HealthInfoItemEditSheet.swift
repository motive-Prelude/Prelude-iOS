//
//  HealthInfoItemEditSheet.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import SwiftUI

struct HealthInfoItemEditSheet: View {
    let healthInfo: HealthInfo
    let selectedKeyPath: PartialKeyPath<HealthInfo>
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    
    var body: some View {
        
        ZStack {
            background
                .ignoresSafeArea()
            
            dragIndicator
            .padding(.top, 12)
            
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Spacer()
                    cancelButton
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                Text(title)
                    .textStyle(.label)
                    .foregroundStyle(PLColor.neutral800)
                    .padding(.bottom, 24)
                
                content()

                Spacer()
                
                PLActionButton(label: "Save", type: .primary, contentType: .text, size: .large, shape: .rect) { dismiss() }
                    .padding(.bottom, keyboardObserver.keyboardHeight >= 0 ? 16 : 11)
                    
            }
            .padding(.horizontal, 16)
            .animation(.easeOut(duration: 0.3), value: keyboardObserver.keyboardHeight)
        }
    }
    
    private var dragIndicator: some View {
        VStack {
            Capsule()
                .frame(width: 56, height: 4)
                .foregroundStyle(PLColor.neutral200)
            Spacer()
        }
    }
    
    private var cancelButton: some View {
        PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { dismiss() }
    }
    
    private var background: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
                
    private var title: String {
        switch selectedKeyPath {
            case \.gestationalWeek: return "Gestational Week"
            case \.height: return "Height, Weight"
            case \.bloodPressure: return "Blood Pressure"
            case \.diabetes: return "Diabetes"
            case \.restrictions: return "Food Restrictions"
            default: return ""
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        switch selectedKeyPath {
            case \.gestationalWeek:
                GestationalWeekGrid(gestationalWeek: healthInfo.gestationalWeek) { week in healthInfo.gestationalWeek = week ?? .early }
            case \.height:
                BmiTextFields(height: Height(healthInfo.height, healthInfo.lastHeightUnit), weight: Weight(healthInfo.weight, healthInfo.lastWeightUnit)) { height, weight in
                    healthInfo.height = height?.value ?? 0.0
                    healthInfo.lastHeightUnit = height?.unit ?? .centimeter
                    
                    healthInfo.weight = weight?.value ?? 0.0
                    healthInfo.lastWeightUnit = weight?.unit ?? .kilogram
                }
            case \.bloodPressure:
                BloodPressureGrid(bloodPressure: healthInfo.bloodPressure) { bloodPressure in healthInfo.bloodPressure = bloodPressure ?? .none }
            case \.diabetes:
                DiabetesGrid(diabetes: healthInfo.diabetes) { diabetes in healthInfo.diabetes = diabetes ?? .none }
            case \.restrictions:
                FoodRestrictionGrid(allergies: healthInfo.restrictions) { allergies in healthInfo.restrictions = allergies }
            default: EmptyView()
        }
    }
}
