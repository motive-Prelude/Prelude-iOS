//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import FirebaseCore
import SwiftUI
import SwiftData

@main
struct JunctionApp: App {
    @StateObject var store = Store()
    @StateObject var navigationManager = NavigationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(SwiftDataManager.shared.container)
                .environmentObject(AlertManager.shared)
                .environmentObject(DIContainer.shared)
                .environmentObject(navigationManager)
                .environmentObject(store)
                
        }
    }
}
