//
//  PreludeFormButton.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLFormButton: View {
    private(set) var label: String? = nil
    private(set) var description: String? = nil
    @Binding var isSelected: Bool
    let contentType: FormButtonContent
    let mode: SizeMode
    var onTap: (() -> ())? = nil
    
    var style: FormButtonStyleData {
        ButtonStyleMapper.style(for: FormButtonStyleKey(contentType: contentType, mode: mode))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            titleView
            descriptionView
        }
        .padding(style.padding)
        .conditionalFrame(mode: mode)
        .background(backgroundView)
        .overlay(borderView)
        .padding(1)
        .onTapGesture {
            withAnimation { isSelected.toggle() }
            onTap?()
        }
        
    }
    
    @ViewBuilder
    private var titleView: some View {
        if let label {
            Text(label)
                .textStyle(.label)
                .foregroundStyle(labelColor)
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        if let description, contentType == .description {
            Text(description)
                .textStyle(.paragraph2)
                .foregroundStyle(style.descriptionColor)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(style.backgroundColor)
    }
    
    @ViewBuilder
    private var borderView: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(.clear)
            .stroke(borderColor, lineWidth: 2)
    }
    
    private var labelColor: Color {
        isSelected ? style.selectedLabelColor : style.defaultLabelColor
    }
    
    private var borderColor: Color {
        isSelected ? style.selectedBorderColor : style.defaultBorderColor
    }
}

#Preview {
    PLFormButton(label: "Label",
                 isSelected: .constant(true),
                 contentType: .labelOnly,
                 mode: .stretch)
    
    PLFormButton(label: "Label",
                 description: "description",
                 isSelected: .constant(true),
                 contentType: .description,
                 mode: .stretch)
    
    PLFormButton(label: "Label",
                 isSelected: .constant(true),
                 contentType: .labelOnly,
                 mode: .hug)
}
