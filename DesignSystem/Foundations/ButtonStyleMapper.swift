//
//  ButtonStyleMapper.swift
//  Junction
//
//  Created by 송지혁 on 11/29/24.
//

import SwiftUI

struct ButtonStyleMapper {
    static private let actionButtonStyles: [ActionButtonStyleKey: ActionButtonStyleData] = [
        ActionButtonStyleKey(type: .primary, size: .large, shape: .rect, contentType: .text, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral800, cornerRadius: 24, height: 60, sizeMode: .stretch),
        
        ActionButtonStyleKey(type: .primary, size: .large, shape: .rect, contentType: .text, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral700, cornerRadius: 24, height: 60, sizeMode: .stretch),
    
        ActionButtonStyleKey(type: .primary, size: .large, shape: .rect, contentType: .text, state: .disabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral200, cornerRadius: 24, height: 60, sizeMode: .stretch),
        
        ActionButtonStyleKey(type: .primary, size: .medium, shape: .rect, contentType: .text, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral800, cornerRadius: 20, height: 52, padding: EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)),
        
        ActionButtonStyleKey(type: .primary, size: .medium, shape: .rect, contentType: .text, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral700, cornerRadius: 20, height: 52, padding: EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)),
        
        ActionButtonStyleKey(type: .primary, size: .medium, shape: .rect, contentType: .text, state: .disabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral200, cornerRadius: 20, height: 52, padding: EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)),
        
        ActionButtonStyleKey(type: .primary, size: .small, shape: .rect, contentType: .text, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral800, cornerRadius: 16, height: 44, padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)),
        
        ActionButtonStyleKey(type: .primary, size: .small, shape: .rect, contentType: .text, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral700, cornerRadius: 16, height: 44, padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)),
        
        ActionButtonStyleKey(type: .primary, size: .small, shape: .rect, contentType: .text, state: .disabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral200, cornerRadius: 16, height: 44, padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)),
        
        ActionButtonStyleKey(type: .primary, size: .medium, shape: .circle, contentType: .icon, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral50, cornerRadius: 0, height: 52, sizeMode: .fixed(52), shadow: .drop(color: PLColor.neutral500, radius: 5, x: 0, y: 4)),
        
        ActionButtonStyleKey(type: .primary, size: .medium, shape: .circle, contentType: .icon, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral100, cornerRadius: 0, height: 52, sizeMode: .fixed(52), shadow: .drop(color: PLColor.neutral500, radius: 5, x: 0, y: 4)),
        
        ActionButtonStyleKey(type: .secondary, size: .large, shape: .rect, contentType: .text, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral200, cornerRadius: 24, height: 60, sizeMode: .stretch),
        
        ActionButtonStyleKey(type: .secondary, size: .large, shape: .rect, contentType: .text, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral300, cornerRadius: 24, height: 60, sizeMode: .stretch),
        
        ActionButtonStyleKey(type: .secondary, size: .large, shape: .rect, contentType: .text, state: .disabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral200, cornerRadius: 24, height: 60, sizeMode: .stretch),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .none, contentType: .text, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral600, backgroundColor: .clear, cornerRadius: 24, height: 44, margin: EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .none, contentType: .text, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral500, backgroundColor: .clear, cornerRadius: 24, height: 44, margin: EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .circle, contentType: .icon, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral100, cornerRadius: 0, height: 40, sizeMode: .fixed(40), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .circle, contentType: .icon, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral200, cornerRadius: 0, height: 40, sizeMode: .fixed(40), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
        
        ActionButtonStyleKey(type: .secondary, size: .small, shape: .square, contentType: .icon, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral100, cornerRadius: 8, height: 28, sizeMode: .fixed(28), margin: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)),
        
        ActionButtonStyleKey(type: .secondary, size: .small, shape: .square, contentType: .icon, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral200, cornerRadius: 8, height: 28, sizeMode: .fixed(28), margin: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)),
        
        ActionButtonStyleKey(type: .secondary, size: .xsmall, shape: .square, contentType: .icon, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral800, cornerRadius: 8, height: 24, sizeMode: .fixed(24), margin: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)),
        
        ActionButtonStyleKey(type: .secondary, size: .xsmall, shape: .square, contentType: .icon, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral50, backgroundColor: PLColor.neutral700, cornerRadius: 8, height: 24, sizeMode: .fixed(24), margin: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .pill, contentType: .seedFull, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral100, cornerRadius: 0, height: 40, padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 16), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .pill, contentType: .seedFull, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral200, cornerRadius: 0, height: 40, padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 16), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .pill, contentType: .seedLow, state: .enabled):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral100, borderColor: PLColor.negative, cornerRadius: 0, height: 40, padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 16), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
        
        ActionButtonStyleKey(type: .secondary, size: .medium, shape: .pill, contentType: .seedLow, state: .pressed):
            ActionButtonStyleData(foregroundColor: PLColor.neutral800, backgroundColor: PLColor.neutral200, borderColor: PLColor.negative, cornerRadius: 0, height: 40, padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 16), margin: EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)),
    ]
    
    static private let formButtonStyles: [FormButtonStyleKey: FormButtonStyleData] = [
        FormButtonStyleKey(contentType: .description, mode: .stretch):
            FormButtonStyleData(defaultLabelColor: PLColor.neutral700,
                                selectedLabelColor: PLColor.neutral800,
                                descriptionColor: PLColor.neutral500,
                                backgroundColor: PLColor.neutral100,
                                defaultBorderColor: .clear,
                                selectedBorderColor: PLColor.neutral800,
                                cornerRadius: 22,
                                padding: EdgeInsets(top: 12,
                                                    leading: 32,
                                                    bottom: 12,
                                                    trailing: 32)),
        
        FormButtonStyleKey(contentType: .labelOnly, mode: .stretch):
            FormButtonStyleData(defaultLabelColor: PLColor.neutral700,
                                selectedLabelColor: PLColor.neutral800,
                                descriptionColor: .clear,
                                backgroundColor: PLColor.neutral100,
                                defaultBorderColor: .clear,
                                selectedBorderColor: PLColor.neutral800,
                                cornerRadius: 16,
                                padding: EdgeInsets(top: 12,
                                                    leading: 0,
                                                    bottom: 12,
                                                    trailing: 0)),
        
        FormButtonStyleKey(contentType: .labelOnly, mode: .hug):
            FormButtonStyleData(defaultLabelColor: PLColor.neutral700,
                                selectedLabelColor: PLColor.neutral800,
                                descriptionColor: .clear,
                                backgroundColor: PLColor.neutral100,
                                defaultBorderColor: .clear,
                                selectedBorderColor: PLColor.neutral800,
                                cornerRadius: 16,
                                padding: EdgeInsets(top: 12,
                                                    leading: 20,
                                                    bottom: 12,
                                                    trailing: 20))
    ]
    
    
    private init() {}
    
    static func style(for key: ActionButtonStyleKey) -> ActionButtonStyleData {
        if actionButtonStyles[key] == nil { assertionFailure("ActionButton에서 디자인 시스템에 없는 조합을 선택했어요.") }
        
        return actionButtonStyles[key] ?? ActionButtonStyleData(foregroundColor: PLColor.neutral50,
                                              backgroundColor: PLColor.neutral800,
                                              cornerRadius: 24,
                                              height: 60,
                                              padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    static func style(for key: FormButtonStyleKey) -> FormButtonStyleData {
        if formButtonStyles[key] == nil { assertionFailure("FormButton에서 디자인 시스템에 없는 조합을 선택했어요.") }
        
        return formButtonStyles[key] ?? FormButtonStyleData(defaultLabelColor: PLColor.neutral700,
                                                      selectedLabelColor: PLColor.neutral800,
                                                      descriptionColor: PLColor.neutral500,
                                                      backgroundColor: PLColor.neutral100,
                                                      defaultBorderColor: .clear,
                                                      selectedBorderColor: PLColor.neutral800,
                                                      cornerRadius: 22,
                                                      padding: EdgeInsets(top: 12,
                                                                          leading: 32,
                                                                          bottom: 12,
                                                                          trailing: 32))
    }
}
