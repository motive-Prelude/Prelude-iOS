//
//  Typography.swift
//  Junction
//
//  Created by 송지혁 on 11/28/24.
//

import SwiftUI

struct EnglishTypographySet {
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

struct KoreanTypographySet {
    static let display = PLTypography(font: .custom("Alike-Regular", size: 48), lineHeight: 12)
    static let heading1 = PLTypography(font: .custom("MaruBuriot-Bold", size: 24), lineHeight: 18)
    static let heading2 = PLTypography(font: .custom("MaruBuriot-Bold", size: 22), lineHeight: 16)
    static let title1 = PLTypography(font: .custom("MaruBuriot-Bold", size: 16), lineHeight: 12)
    static let title2 = PLTypography(font: .custom("Pretendard-Regular", size: 20), lineHeight: 12)
    static let label = PLTypography(font: .custom("Pretendard-SemiBold", size: 16), lineHeight: 10)
    static let paragraph1 = PLTypography(font: .custom("Pretendard-Regular", size: 16), lineHeight: 12)
    static let paragraph2 = PLTypography(font: .custom("Pretendard-Regular", size: 14), lineHeight: 10)
    static let caption = PLTypography(font: .custom("Pretendard-Regular", size: 12), lineHeight: 9)
}

struct PLTypographySet {
    let display: PLTypography
    let heading1: PLTypography
    let heading2: PLTypography
    let title1: PLTypography
    let title2: PLTypography
    let label: PLTypography
    let paragraph1: PLTypography
    let paragraph2: PLTypography
    let caption: PLTypography
}

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


struct PLTypographySetKey: EnvironmentKey {
    static let defaultValue = PLTypographySet(display: EnglishTypographySet.display,
                                              heading1: EnglishTypographySet.heading1,
                                              heading2: EnglishTypographySet.heading2,
                                              title1: EnglishTypographySet.title1,
                                              title2: EnglishTypographySet.title2,
                                              label: EnglishTypographySet.label,
                                              paragraph1: EnglishTypographySet.paragraph1,
                                              paragraph2: EnglishTypographySet.paragraph2,
                                              caption: EnglishTypographySet.caption)
}

extension EnvironmentValues {
    var plTypographySet: PLTypographySet {
        get { self[PLTypographySetKey.self] }
        set { self[PLTypographySetKey.self] = newValue }
    }
}
