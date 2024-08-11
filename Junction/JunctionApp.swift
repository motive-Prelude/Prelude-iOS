//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import SwiftUI

@main
struct JunctionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationManager())
        }
    }
}
