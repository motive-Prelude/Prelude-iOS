//
//  PreludeToggle.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLToggle<Leading: ToggleUnit, Trailing: ToggleUnit>: View {
    @Binding var isLeftSelected: Bool
    
    let leading: (Binding<Bool>) -> Leading
    let trailing: (Binding<Bool>) -> Trailing

    
    
    var body: some View {
        HStack(spacing: 0) {
            leading($isLeftSelected)
                .onTapGesture {
                    withAnimation {
                        isLeftSelected = true
                    }
                }
            
            trailing(.constant(!isLeftSelected))
                .onTapGesture {
                    withAnimation {
                        isLeftSelected = false
                    }
                }
        }
        .padding(4)
        .background { RoundedRectangle(cornerRadius: 16).fill(.neutral100)}
    }
}

#Preview {
    @Previewable @State var isLeftSelected = true

    PLToggle(isLeftSelected: $isLeftSelected) { binding in
        PLToggleOption(unit: Height.Unit.centimeter, isSelected: binding)
    } trailing: { binding in
        PLToggleOption(unit: Height.Unit.feet, isSelected: binding)
    }

}
