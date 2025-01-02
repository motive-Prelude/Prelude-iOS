//
//  PreludeButtonStyle.swift
//  Junction
//
//  Created by 송지혁 on 11/29/24.
//

import SwiftUI

struct PreludeActionButtonStyle: ButtonStyle {
    let type: ButtonType
    let size: ButtonSize
    let shape: ButtonShape
    let content: ActionButtonContent
    var isDisabled: Bool
    var directionalForegroundColor: Color?
    var directionalBackgroundColor: Color?
    
    func makeBody(configuration: Configuration) -> some View {
        let state: ActionButtonState = isDisabled ? .disabled : (configuration.isPressed ? .pressed : .enabled)
        
        let styleKey = ActionButtonStyleKey(type: type,
                                      size: size,
                                      shape: shape,
                                      contentType: content,
                                      state: state)
        
        let style = ButtonStyleMapper.style(for: styleKey)
        
        configuration.label
            .foregroundStyle(directionalForegroundColor == nil ? style.foregroundColor : directionalForegroundColor!)
            .conditionalFrame(mode: style.sizeMode, height: style.height)
            .padding(style.padding)
            .background {
                shape.backgroundShape()
                    .fill(directionalBackgroundColor == nil ? style.backgroundColor : directionalBackgroundColor!)
                    .cornerRadius(style.cornerRadius)
            }
            .overlay {
                shape.backgroundShape()
                    .fill(.clear)
                    .stroke(style.borderColor, lineWidth: 1, antialiased: true)
                    
            }
            .padding(style.margin)
            .contentShape(Rectangle())
    }
}
