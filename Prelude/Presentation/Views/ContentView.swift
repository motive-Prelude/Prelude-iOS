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
                        .trackScreen(screenName: "메인 뷰")
                } else {
                    InfoSetUpStartView()
                        .trackScreen(screenName: "건강 정보 입력 시작 뷰")
                }
            } else {
                OnboardingPage()
                    .trackScreen(screenName: "온보딩 뷰")
            }
        }
        .animation(.linear(duration: 0.5), value: userSession.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
