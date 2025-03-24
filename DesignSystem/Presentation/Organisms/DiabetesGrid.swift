//
//  DiabetesGrid.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct DiabetesGrid: View {
    
    @State var diabetes: Diabetes?
    let result: (Diabetes?) -> ()
    
    var body: some View {
        Grid {
            GridRow {
                PLFormButton(label: Diabetes.none.localized,
                             isSelected: bindingForDiabetes(Diabetes.none),
                             contentType: .labelOnly,
                             mode: .stretch)
                .gridCellColumns(3)
                .onTapGesture { diabetes = Diabetes.none }
            }
            
            GridRow {
                PLFormButton(label: Diabetes.type1.localized,
                             isSelected: bindingForDiabetes(Diabetes.type1),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.type1 }
                
                PLFormButton(label: Diabetes.type2.localized,
                             isSelected: bindingForDiabetes(Diabetes.type2),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.type2 }
                
                PLFormButton(label: Diabetes.gestational.localized,
                             isSelected: bindingForDiabetes(Diabetes.gestational),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.gestational }
            }
        }
        .onChange(of: diabetes) { _, newValue in result(newValue) }
    }
    
    private func bindingForDiabetes(_ diabetes: Diabetes) -> Binding<Bool> {
        Binding(
            get: { self.diabetes == diabetes },
            set: { isSelected in
                self.diabetes = isSelected ? diabetes : nil
            }
        )
    }
}

#Preview {
    DiabetesGrid() { _ in }
}
