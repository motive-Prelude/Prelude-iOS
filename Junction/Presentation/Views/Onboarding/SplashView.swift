//
//  SplashView.swift
//  Junction
//
//  Created by 송지혁 on 12/27/24.
//

import Lottie
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationManager.screenPath) {
                ZStack {
                    background
                    content
                }
                .navigationDestination(for: AppScreen.self) { appscreen in
                    appscreen.destination
                }
            }
            .disabled(alertManager.isAlertVisible)
            .onAppear { navigateToContentView() }
            
            alert
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
        Text("Prelude")
            .textStyle(.heading2)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    private var alert: some View {
        if alertManager.isAlertVisible {
            CustomAlertView()
                .zIndex(1)
        }
    }
    
    private func navigateToContentView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            navigationManager.navigate(.content)
        }
    }
}
