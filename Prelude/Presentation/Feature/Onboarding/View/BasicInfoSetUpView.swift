//
//  HealthInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import SwiftUI

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
        Text(Localization.GestationalWeek.gestationalWeeksQuestion)
            .textStyle(typographies.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var heightAndWeightInstruction: some View {
        Text(Localization.PhysicalInfo.heightAndWeightQuestion)
            .textStyle(typographies.title1)
            .foregroundStyle(PLColor.neutral800)
    }
}
