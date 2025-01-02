//
//  Typography.swift
//  Junction
//
//  Created by 송지혁 on 11/28/24.
//

import SwiftUI

struct PLTypography {
    let font: Font
    let lineHeight: CGFloat
    
    static let display = PLTypography(font: .custom("Alike-Regular", size: 48), lineHeight: 12)
    static let heading1 = PLTypography(font: .custom("Alike-Regular", size: 28), lineHeight: 8)
    static let heading2 = PLTypography(font: .custom("Alike-Regular", size: 24), lineHeight: 8)
    static let title1 = PLTypography(font: .custom("Alike-Regular", size: 18), lineHeight: 6)
    static let title2 = PLTypography(font: .custom("Inter-Regular", size: 20), lineHeight: 4)
    static let label = PLTypography(font: .custom("Inter-Regular_SemiBold", size: 16), lineHeight: 4)
    static let paragraph1 = PLTypography(font: .custom("Inter-Regular", size: 16), lineHeight: 8)
    static let paragraph2 = PLTypography(font: .custom("Inter-Regular", size: 14), lineHeight: 6)
    static let caption = PLTypography(font: .custom("Inter-Regular", size: 12), lineHeight: 6)
}
