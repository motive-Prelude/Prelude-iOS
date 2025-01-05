//
//  PrimaryButton.swift
//  Junction
//
//  Created by 송지혁 on 11/26/24.
//

import SwiftUI

struct PLActionButton: View {
    private(set) var label: String? = nil
    private(set) var icon: Image? = nil
    let type: ButtonType
    let contentType: ActionButtonContent
    let size: ButtonSize
    let shape: ButtonShape
    var isDisabled = false
    var directionalForegroundColor: Color? = nil
    var directionalBackgroundColor: Color? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                iconView
                titleView
            }
        }
        .plButtonStyle(type, size: size, shape: shape, content: contentType, isDisabled: isDisabled,
                       directionalForegroundColor: directionalForegroundColor,
                       directionalBackgroundColor: directionalBackgroundColor)
        .disabled(isDisabled)
    }
    
    @ViewBuilder
    private var iconView: some View {
        if let icon {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
        }
    }
    
    @ViewBuilder
    private var titleView: some View {
        if let label {
            Text(label)
                .textStyle(.label)
        }
    }
    
    private var iconSize: CGFloat {
        switch (type, size, shape) {
            case (.primary, .medium, .circle): return 32
            case (.secondary, .medium, .circle): return 24
            case (.secondary, .small, .square): return 20
            case (.secondary, .xsmall, .square): return 16
            case (.secondary, .medium, .pill): return 36
            default: return 0
                
        }
    }
}

#Preview {
    PLActionButton(label: "Label",
                  type: .primary,
                  contentType: .text,
                  size: .large,
                  shape: .rect) {
        print("Hello World!")
    }
    
    PLActionButton(label: "Label",
                  type: .primary,
                  contentType: .text,
                  size: .medium,
                  shape: .rect) {
        print("Hello World!")
    }
    
    PLActionButton(icon: Image(.capture),
                  type: .primary,
                  contentType: .icon,
                  size: .medium,
                  shape: .circle) {
        print("Hello World!")
    }
    
    PLActionButton(label: "Label",
                  type: .primary,
                  contentType: .text,
                  size: .small,
                  shape: .rect) {
        print("Hello World!")
    }
    
    Divider()
    
    PLActionButton(label: "Label",
                  type: .secondary,
                  contentType: .text,
                  size: .large,
                  shape: .rect) {
        print("Hello World!")
    }
    
    PLActionButton(label: "Label",
                  type: .secondary,
                  contentType: .text,
                  size: .medium,
                  shape: .none) {
        print("Hello World!")
    }
    
    PLActionButton(icon: Image(.setting),
                  type: .secondary,
                  contentType: .icon,
                  size: .medium,
                  shape: .circle) {
        print("Hello World!")
    }
    
    PLActionButton(icon: Image(.close),
                  type: .secondary,
                  contentType: .icon,
                  size: .small,
                  shape: .square) {
        print("Hello World!")
    }
    
    PLActionButton(icon: Image(.closeSmall),
                  type: .secondary,
                  contentType: .icon,
                  size: .xsmall,
                  shape: .square) {
        print("Hello World!")
    }
    
    PLActionButton(label: "10",
                  icon: Image(.logo),
                  type: .secondary,
                  contentType: .seedFull,
                  size: .medium,
                  shape: .pill) {
        print("Hello World!")
    }
    
    PLActionButton(label: "0",
                  icon: Image(.logo),
                  type: .secondary,
                  contentType: .seedLow,
                  size: .medium,
                  shape: .pill) {
        print("Hello World!")
    }
}
