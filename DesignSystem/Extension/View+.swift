//
//  View+.swift
//  Junction
//
//  Created by 송지혁 on 11/25/24.
//

import SwiftUI

extension View {
    func textStyle(_ typography: PLTypography) -> some View {
        self
            .font(typography.font)
            .lineSpacing(typography.lineHeight)
    }
}

extension View {
    
    @ViewBuilder
    func conditionalFrame(mode: SizeMode, height: CGFloat? = nil) -> some View {
        switch mode {
            case .fixed(let width):
                self.frame(width: width, height: height)
            case .stretch:
                if let height {
                    self.frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
                } else {
                    self.frame(maxWidth: .infinity)
                }
            case .hug: self.frame(height: height)
        }
    }
}


// MARK: ButtonStyles
extension View {
    @ViewBuilder
    func plButtonStyle(_ type: ButtonType,
                       size: ButtonSize,
                       shape: ButtonShape,
                       content: ActionButtonContent,
                       isDisabled: Bool,
                       directionalForegroundColor: Color? = nil,
                       directionalBackgroundColor: Color? = nil) -> some View {
        self
            .buttonStyle(PreludeActionButtonStyle(type: type,
                                                  size: size,
                                                  shape: shape,
                                                  content: content,
                                                  isDisabled: isDisabled,
                                                  directionalForegroundColor: directionalForegroundColor,
                                                  directionalBackgroundColor: directionalBackgroundColor))
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension View {
    func trackScreen(screenName: String) -> some View {
        self.modifier(ScreenTrackingModifier(screenName: screenName))
    }
}

struct ConditionalSafeAreaModifier: ViewModifier {
    func body(content: Content) -> some View {
        let safeEdges: Edge.Set = UIDevice.current.userInterfaceIdiom == .pad ? [.horizontal] : [.horizontal, .top, .bottom]
        return content.ignoresSafeArea(.all, edges: safeEdges)
    }
}

extension View {
    func applyConditionalSafeArea() -> some View {
        self.modifier(ConditionalSafeAreaModifier())
    }
}
