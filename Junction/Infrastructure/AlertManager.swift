//
//  AlertManager.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import SwiftUI

struct AlertAction: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var isAlertVisible = false
    @Published var title = ""
    @Published var message = ""
    @Published var actions: [AlertAction] = []
    
    private init() { }
    
    func showAlert(title: String, message: String, actions: [AlertAction]) {
        self.title = title
        self.message = message
        self.actions = actions
        isAlertVisible = true
    }
    
    func hideAlert() { isAlertVisible = false }
}
