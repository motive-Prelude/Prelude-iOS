//
//  OnboardingView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import AuthenticationServices
import SwiftUI

struct OnboardingPage: View {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.plTypographySet) var typographies
    
    enum TabSelection: Int, CaseIterable, Hashable {
        case onboarding1 = 1
        case onboarding2
        
        static var totalCount: Int { allCases.count }
    }
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            background
                
            VStack(spacing: 32) {
                tabs
                Group {
                    pageIndicator
                        .padding(.top, -32)
                    Spacer()
                    appleLoginButton
                        .padding(.horizontal, 16)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    private var background: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    private var tabs: some View {
        TabView(selection: $currentPage) {
            OnboardingTabContent(image: Image(.onboarding1),
                                 title: Localization.Label.firstOnboardingTitle,
                                 description: Localization.Label.firstOnboardingDescription)
            .tag(0)
            
            OnboardingTabContent(image: Image(.onboarding2),
                                 title: Localization.Label.secondOnboardingTitle,
                                 description: Localization.Label.secondOnboardingDescription)
            .tag(1)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        
    }
    private var pageIndicator: some View {
        PLPageIndicator(currentPage: $currentPage, totalCount: TabSelection.totalCount)
    }
    private var appleLoginButton: some View {
        SignInWithAppleButton(.continue) { request in
            onboardingViewModel.prepareAppleLogin(request: request)
        } onCompletion: { result in
            onboardingViewModel.makeAppleLoginCredential(result: result) { parameter in
                Task { await userSession.login(parameter: parameter) }
            }
        }
        .textStyle(typographies.label)
        .foregroundStyle(PLColor.neutral50)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .frame(height: 60)
    }
}

#Preview {
    OnboardingPage()
}
