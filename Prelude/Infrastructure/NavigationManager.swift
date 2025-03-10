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
        if let last = screenPath.last, last == destination { return }
        
        screenPath.append(destination)
    }
    
    func previous() {
        if screenPath.isEmpty { return }
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
    case result(foodName: String, image: UIImage?)
    
    
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
            case .result(let foodName, let image):
                ResultView(foodName: foodName, image: image)
        }
    }
    
    var name: String {
        switch self {
            case .content: return "Content"
            case .onboarding: return "Onboarding"
            case .infoSetupStart: return "Info Setup Start"
            case .healthInfoSetup: return "Health Info Setup"
            case .healthInfoConfirm: return "Health Info Confirm"
            case .welcome: return "Welcome"
            case .healthInfoEdit: return "Health Info Edit"
            case .disclaimer: return "Disclaimer"
            case .main: return "Main"
            case .setting: return "Setting"
            case .account: return "Account"
            case .purchase: return "Purchase"
            case .result: return "Result"
        }
    }
}


