//
//  View+.swift
//  Junction
//
//  Created by 송지혁 on 11/25/24.
//

import SwiftUI

extension View {
    func textStyle(_ typography: DesignTokens.Typography) -> some View {
        self
            .font(typography.style.font)
            .lineSpacing(typography.style.lineHeight)
    }
}
