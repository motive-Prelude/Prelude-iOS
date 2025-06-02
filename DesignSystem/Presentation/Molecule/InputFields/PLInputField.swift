//
//  InputField.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct PLInputField<Payload: Measurable>: View where Payload.Unit.Value: FloatingPoint {
    @State var isLeftSelected: Bool = true
    @State var value: [Payload.Unit: Payload.Unit.Value] = [:]
    
    let leftUnit: Payload.Unit
    let rightUnit: Payload.Unit
    
    private var validUnits: [Payload.Unit] { isLeftSelected ? leftUnit.subUnits : rightUnit.subUnits }
    
    let result: (Payload) -> ()
    
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
        .onChange(of: value) { _, _ in
            guard let unit = value.first?.key else { return }
            result(Payload(calculateValue(), unit))
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
    
    private func binding(_ unit: Payload.Unit) -> Binding<String> {
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
    
    private func calculateValue() -> Payload.Unit.Value {
        value.reduce(.zero) { total, entry in
            total + entry.key.toBaseUnit(entry.value)
        }
    }
}

#Preview {
    
}
