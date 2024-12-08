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
    case onboarding
    case healthInfoSetup
    case healthInfoEdit(healthInfo: HealthInfo, contentMode: ListItemType)
    case disclaimer
    case main
    case result(userSelectPrompt: String, image: UIImage?)
    
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .onboarding:
                OnboardingView()
            case .healthInfoSetup:
                HealthInfoSetUpPage()
            case .healthInfoEdit(healthInfo: let healthInfo, contentMode: let contentMode):
                HealthInfoEditView(healthInfo: healthInfo, mode: contentMode)
            case .disclaimer:
                DisclaimerView()
            case .main:
                MainView()
            case .result(let userSelectedPrompt, let image):
                ResultView(userSelectedPrompt: userSelectedPrompt, image: image)
        }
    }
}


