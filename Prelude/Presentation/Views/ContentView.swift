//
//  ContentView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        ZStack {
            if userSession.isAuthenticated {
                if let userInfo = userSession.userInfo, userInfo.didAgreeToTermsAndConditions {
                    MainView()
                } else {
                    InfoSetUpStartView()
                }
            } else {
                OnboardingPage()
            }
        }
        .animation(.linear(duration: 0.5), value: userSession.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
