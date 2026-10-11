//
//  PLToggleUnit.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

protocol ToggleUnit: View {}

struct PLToggleOption<Unit: MeasurableUnit>: ToggleUnit {
    let unit: Unit
    @Binding var isSelected: Bool
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        Group {
            Text(unit.symbol)
                .textStyle(typographies.label)
                .foregroundStyle(foregroundColor)
                .frame(width: 42, height: 36)
                .background(backgroundView)
        }
    }
    
    private var foregroundColor: Color { isSelected ? PLColor.neutral800 : PLColor.neutral500 }
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundStyle)
    }
    private var backgroundStyle: AnyShapeStyle {
        isSelected ? AnyShapeStyle(PLColor.neutral50
            .shadow(.drop(color: .neutral500.opacity(0.2), radius: 5, x: 0, y: 0))) :
        AnyShapeStyle(Color.clear
            .shadow(.drop(color: .clear, radius: 0, x: 0, y: 0)))
    }
    
}
