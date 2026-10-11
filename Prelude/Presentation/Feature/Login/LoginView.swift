//
//  OnboardingView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import AuthenticationServices
import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    
    @Environment(\.plTypographySet) var typographies
    
    @Bindable var store: StoreOf<LoginReducer>
    
    enum Page: Int, CaseIterable, Hashable {
        case first
        case second
        
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
                    
                    Button("Login") { store.send(.loginButtonTapped(.apple)) }
                    
                    SignInWithAppleButton(.continue) { request in
                        store.send(.loginButtonTapped(.apple))
                    } onCompletion: { result in
                        
                    }
                    .textStyle(typographies.label)
                    .foregroundStyle(PLColor.neutral50)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(height: 60)
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
            .tag(Page.first.rawValue)
            
            OnboardingTabContent(image: Image(.onboarding2),
                                 title: Localization.Label.secondOnboardingTitle,
                                 description: Localization.Label.secondOnboardingDescription)
            .tag(Page.second.rawValue)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        
    }
    private var pageIndicator: some View {
        PLPageIndicator(currentPage: $currentPage, totalCount: Page.totalCount)
    }
}
