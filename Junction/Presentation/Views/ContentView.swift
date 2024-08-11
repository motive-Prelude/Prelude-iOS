//
//  ContentView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.screenPath) {
            OnboardingView()
                .navigationDestination(for: AppScreen.self) { appscreen in
                    appscreen.destination
                }
        }
    }
}

#Preview {
    ContentView()
}
