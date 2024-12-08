//
//  AllergiesInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct AllergiesInfoSetUpView: View {
    @Binding var allergies: [Bool]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            allergiesInstruction
                .padding(.bottom, 8)
            checkInstruction
                .padding(.bottom, 12)
            allergyGrid
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
    
    private var allergyGrid: some View {
        FlowLayout(spacing: 8) {
            ForEach(Allergies.allCases, id: \.self) { allergy in
                PLFormButton(label: allergy.rawValue,
                             isSelected: bindingForAllergy(allergy),
                             contentType: .labelOnly,
                             mode: .hug)
                
            }
            
        }
    }
    
    private func bindingForAllergy(_ allergy: Allergies) -> Binding<Bool> {
        guard let index = Allergies.allCases.firstIndex(of: allergy) else {
            return .constant(false)
        }
        return Binding(
            get: { allergies[index] },
            set: { allergies[index] = $0 }
        )
    }
}

#Preview {
    @Previewable @State var allergies = Array(repeating: false, count: Allergies.totalCount)
    AllergiesInfoSetUpView(allergies: $allergies)
}
