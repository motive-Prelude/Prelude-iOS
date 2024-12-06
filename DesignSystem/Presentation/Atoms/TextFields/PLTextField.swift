//
//  PLTextField.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLTextField<Unit: MeasurableUnit>: View {
    let placeholder: String
    @Binding var text: String
    private(set) var unit: Unit?
    let keyboard: UIKeyboardType
    @FocusState var isFocused: Bool
    var onFocused: ((Bool) -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .leading) {
                placeholderView
                textField

            }
            .padding(.leading, 12)
            .padding(.vertical, 10)
            unitView
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
        .background(backgroundView)
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .onChange(of: isFocused) { _, _ in onFocused?(isFocused) }
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        if text.isEmpty {
            Text(placeholder)
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral500)
        }
    }
    private var textField: some View {
        TextField("", text: $text, axis: .horizontal)
            .textStyle(.paragraph1)
            .foregroundStyle(PLColor.neutral800)
            .fixedSize(horizontal: true, vertical: false)
            .focused($isFocused)
            .keyboardType(keyboard)
    }
    
    @ViewBuilder
    private var unitView: some View {
        if let unit, !text.isEmpty {
            Text(unit.symbol)
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral500)
                .transition(.opacity)
        }
    }
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.clear)
            .stroke(PLColor.neutral300, lineWidth: 1)
    }
}

#Preview {
    @Previewable @State var text = ""
    
    PLTextField(placeholder: "Placeholder",
                text: $text,
                unit: HeightUnit.centimeter,
                keyboard: .numberPad)
}
