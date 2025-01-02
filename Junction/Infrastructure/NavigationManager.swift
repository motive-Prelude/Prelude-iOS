//
//  NavigationManager.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var screenPath: [AppScreen] = []
    @Published var showMemories = true

    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $screenPath
            .sink { _ in
                
            } receiveValue: { appscreens in
                if appscreens.isEmpty {
                    self.showMemories = true
                } else {
                    self.showMemories = false
                }
            }
            .store(in: &cancellables)
        
    }
    
    func navigate(_ destination: AppScreen) {
        screenPath.append(destination)
    }
    
    func previous() {
        screenPath.removeLast()
    }
}

enum AppScreen: Hashable, Identifiable {
    case content
    case onboarding
    case infoSetupStart
    case healthInfoSetup
    case healthInfoConfirm(healthInfo: HealthInfo, contentMode: ListItemType)
    case welcome
    case healthInfoEdit(healthInfo: HealthInfo, contentMode: ListItemType)
    case disclaimer
    case main
    case setting
    case account
    case purchase
    case result(userSelectPrompt: String, image: UIImage?)
    
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .content:
                ContentView()
            case .onboarding:
                OnboardingPage()
            case .infoSetupStart:
                InfoSetUpStartView()
            case .healthInfoSetup:
                HealthInfoSetUpPage()
            case .healthInfoConfirm(healthInfo: let healthInfo, contentMode: let contentMode):
                HealthInfoConfirmView(healthInfo: healthInfo, mode: contentMode)
            case .welcome:
                WelcomeView()
            case .healthInfoEdit(healthInfo: let healthInfo, contentMode: let contentMode):
                HealthInfoEditView(healthInfo: healthInfo, mode: contentMode)
            case .disclaimer:
                DisclaimerView()
            case .main:
                MainView()
            case .setting:
                SettingView()
            case .account:
                AccountView()
            case .purchase:
                PurchaseView()
            case .result(let userSelectedPrompt, let image):
                ResultView(userSelectedPrompt: userSelectedPrompt, image: image)
        }
    }
}


