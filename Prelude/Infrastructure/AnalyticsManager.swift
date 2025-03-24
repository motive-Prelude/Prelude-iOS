//
//  AnalyticsManager.swift
//  Prelude
//
//  Created by 송지혁 on 1/8/25.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    func logScreenView(_ screen: AppScreen?) {
        guard let screen else { return }
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screen.name,
                AnalyticsParameterScreenClass: ""
        ])
    }
    
    func logScreen(_ name: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: name])
    }
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
