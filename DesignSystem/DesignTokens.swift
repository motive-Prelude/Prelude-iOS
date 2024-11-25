//
//  DesignTokens.swift
//  Junction
//
//  Created by 송지혁 on 11/25/24.
//

import SwiftUI

struct DesignTokens {
    struct TextStyle {
        let font: Font
        let lineHeight: CGFloat
    }
    
    enum Typography {
        case display
        case heading1
        case heading2
        case title1
        case title2
        case label
        case paragraph1
        case paragraph2
        case caption
        
        
        var style: TextStyle {
            switch self {
                case .display:
                    return TextStyle(font: Font.custom("Alike-Regular", size: 48), lineHeight: 12)
                case .heading1:
                    return TextStyle(font: Font.custom("Alike-Regular", size: 28), lineHeight: 8)
                case .heading2:
                    return TextStyle(font: Font.custom("Alike-Regular", size: 24), lineHeight: 8)
                case .title1:
                    return TextStyle(font: Font.custom("Alike-Regular", size: 18), lineHeight: 6)
                case .title2:
                    return TextStyle(font: Font.custom("Inter-Regular", size: 20), lineHeight: 4)
                case .label:
                    return TextStyle(font: Font.custom("Inter-Regular_SemiBold", size: 16), lineHeight: 4)
                case .paragraph1:
                    return TextStyle(font: Font.custom("Inter-Regular", size: 16), lineHeight: 8)
                case .paragraph2:
                    return TextStyle(font: Font.custom("Inter-Regular", size: 14), lineHeight: 6)
                case .caption:
                    return TextStyle(font: Font.custom("Inter-Regular", size: 12), lineHeight: 6)
            }
        }
    }
}
