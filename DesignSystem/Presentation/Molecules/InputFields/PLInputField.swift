//
//  InputField.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct PLInputField<Unit: MeasurableUnit>: View {
    @Binding var isLeftSelected: Bool
    @Binding var value: [Unit: Unit.Value]
    
    let leftUnit: Unit
    let rightUnit: Unit
    
    private var validUnits: [Unit] { isLeftSelected ? leftUnit.subUnits : rightUnit.subUnits }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(validUnits, id: \.self) { unit in
                PLTextField(placeholder: unit.placeholder,
                            text: binding(unit),
                            unit: unit,
                            keyboard: .numberPad)
            }
            
            PLToggle(isLeftSelected: $isLeftSelected) { binding in
                PLToggleOption(unit: leftUnit, isSelected: binding)
            } trailing: { binding in
                PLToggleOption(unit: rightUnit, isSelected: binding)
            }
        }
        .onChange(of: validUnits) { _, _ in value.removeAll() }
        .onChange(of: value) { _, _ in dump(value) }
        
    }
    
    private func binding(_ unit: Unit) -> Binding<String> {
        Binding(
            get: {
                if let value = value[unit] { return unit.toString(value) }
                else { return "" }
            },
            set: { newValue in
                if let convertedValue = unit.fromString(newValue) {
                    value[unit] = convertedValue
                } else { value.removeValue(forKey: unit) }
            }
        )
    }
}

#Preview {
    
}
