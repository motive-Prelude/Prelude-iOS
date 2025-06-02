//
//  SplashView.swift
//  Junction
//
//  Created by 송지혁 on 12/27/24.
//

import ComposableArchitecture
import Lottie
import SwiftUI

struct SplashView: View {
    @Environment(\.plTypographySet) var typographies
    
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.router.path, action: \.router.path)) {
            ZStack {
                background
                content
            }
            .task {
                store.send(.task)
                store.send(.restoreSession)
            }
            
        } destination: { store in
            switch store.case {
                case .login(let store):
                    LoginView(store: store)
                case .main(let store):
                    MainView(store: store)
                case .healthSetupStart(let store):
                    InfoSetUpStartView(store: store)
                case .healthSetup(let store):
                    HealthInfoSetUpPage(store: store)
                case .healthConfirm(let store):
                    HealthInfoConfirmView(store: store)
                case .disclaimer(let store):
                    DisclaimerView(store: store)
                case .welcome(let store):
                    WelcomeView(store: store)
                case .setting(let store):
                    SettingView(store: store)
                case .account(let store):
                    AccountView(store: store)
                case .healthEdit(let store):
                    HealthInfoEditView(store: store)
                case .result(let store):
                    ResultView(store: store)
            }
        }
        .overlay(alignment: .top) {
            if store.toast.isVisible { toast }
        }
    }
    
    private var background: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            logo
            title
        }
    }
    
    private var logo: some View {
        LottieView(animation: .named("splashTangtang"))
            .looping()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
    }
    private var title: some View {
        Text(Localization.Label.appName)
            .textStyle(typographies.heading2)
            .foregroundStyle(.black)
    }
    
    private var toast: some View {
        PLToast(icon: store.toast.icon, message: store.toast.message)
            .transition(.opacity.combined(with: .move(edge: .top)))
    }
}
