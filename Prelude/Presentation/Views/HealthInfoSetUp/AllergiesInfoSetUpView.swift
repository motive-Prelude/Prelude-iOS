//
//  AllergiesInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct AllergiesInfoSetUpView: View {
    @Binding var allergies: [Allergies]
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            allergiesInstruction
                .padding(.bottom, 8)
            checkInstruction
                .padding(.bottom, 12)
            FoodRestrictionGrid(allergies: allergies) { allergies in self.allergies = allergies }
        }
    }
    
    private var allergiesInstruction: some View {
        Text(Localization.Allergy.sensitivitiesQuestion)
            .textStyle(typographies.title1)
            .foregroundStyle(PLColor.neutral800)
            .minimumScaleFactor(0.1)
    }
    
    private var checkInstruction: some View {
        Text(Localization.Allergy.checkAllInstruction)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral500)
            .minimumScaleFactor(0.1)
    }
}
