//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import SwiftUI

@main
struct JunctionApp: App {
    @StateObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationManager())
                .environmentObject(store)
        }
    }
}
