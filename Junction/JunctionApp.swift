//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import SwiftUI
import SwiftData

@main
struct JunctionApp: App {
    @StateObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            MainView()
                .environmentObject(NavigationManager())
                .modelContainer(SwiftDataManager.shared.container)
                .environmentObject(store)
        }
    }
}
