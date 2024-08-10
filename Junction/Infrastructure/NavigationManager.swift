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

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case main
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .main:
                MainView()
        }
    }
}


