//
//  ScreenTrackingModifier.swift
//  Prelude
//
//  Created by 송지혁 on 1/9/25.
//

import FirebaseAnalytics
import SwiftUI

struct ScreenTrackingModifier: ViewModifier {
    let screenName: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsManager.shared.logScreen(screenName)
            }
    }
}
