//
//  AllergiesInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct AllergiesInfoSetUpView: View {
    @Binding var allergies: [Allergies]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            allergiesInstruction
                .padding(.bottom, 8)
            checkInstruction
                .padding(.bottom, 12)
            FoodRestrictionGrid { allergies in self.allergies = allergies }
        }
    }
    
    private var allergiesInstruction: some View {
        Text("Do you have any allergies or food sensitivities?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var checkInstruction: some View {
        Text("Check all that apply")
            .textStyle(.paragraph2)
            .foregroundStyle(PLColor.neutral500)
    }
}
