//
//  BloodPressureGrid.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct BloodPressureGrid: View {
    
    @State var bloodPressure: BloodPressure?
    
    let result: (BloodPressure?) -> ()
    
    var body: some View {
        Grid {
            GridRow {
                PLFormButton(label: BloodPressure.none.localized,
                             isSelected: bindingForBloodPressure(BloodPressure.none),
                             contentType: .labelOnly,
                             mode: .stretch)
                .gridCellColumns(2)
                .onTapGesture { bloodPressure = BloodPressure.none }
            }
            
            GridRow {
                PLFormButton(label: BloodPressure.hypotension.localized,
                             isSelected: bindingForBloodPressure(BloodPressure.hypotension),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { bloodPressure = .hypotension }
                
                PLFormButton(label: BloodPressure.hypertension.localized,
                             isSelected: bindingForBloodPressure(BloodPressure.hypertension),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { bloodPressure = .hypertension }
            }
        }
        .onChange(of: bloodPressure) { _, newValue in result(newValue) }
    }
    
    private func bindingForBloodPressure(_ bloodPressure: BloodPressure) -> Binding<Bool> {
        Binding(
            get: { self.bloodPressure == bloodPressure },
            set: { isSelected in
                self.bloodPressure = isSelected ? bloodPressure : nil
            }
        )
    }
}

#Preview {
    BloodPressureGrid() { _ in }
}
