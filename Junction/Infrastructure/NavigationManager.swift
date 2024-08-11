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
}

enum AppScreen: Hashable, Identifiable {
    case onboarding
    case healthInfoSetup
    case healthCheck(healthInfo: HealthInfo)
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
                HealthInfoSetUpView()
            case .healthCheck(let healthInfo):
                HealthCheckView(healthInfo: healthInfo)
            case .main:
                MainView()
            case .result(let userSelectedPrompt, let image):
                ResultView(userSelectedPrompt: userSelectedPrompt, image: image)
        }
    }
}


