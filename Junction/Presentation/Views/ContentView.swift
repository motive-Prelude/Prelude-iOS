//
//  ContentView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationManager.screenPath) {
                DisclaimerView()
                    .navigationDestination(for: AppScreen.self) { appscreen in
                        appscreen.destination
                    }
            }
            .disabled(alertManager.isAlertVisible)
            
            if alertManager.isAlertVisible {
                CustomAlertView()
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
