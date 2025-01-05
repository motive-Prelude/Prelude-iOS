//
//  FoodRestrictionGrid.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct FoodRestrictionGrid: View {
    
    @State var allergies: [Allergies] = []
    
    let result: ([Allergies]) -> ()
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(Allergies.allCases, id: \.self) { allergy in
                PLFormButton(label: allergy.rawValue,
                             isSelected: bindingForAllergy(allergy),
                             contentType: .labelOnly,
                             mode: .hug)
                
            }
        }
        .onChange(of: allergies) { _, newValue in result(allergies) }
    }
    
    private func bindingForAllergy(_ allergy: Allergies) -> Binding<Bool> {
        return Binding(
            get: { allergies.contains(allergy) },
            set: { isSelected in isSelected ? allergies.append(allergy) : allergies.removeAll { $0 == allergy } }
        )
    }
}

#Preview {
    FoodRestrictionGrid() { _ in }
}
