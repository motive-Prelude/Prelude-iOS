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
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertActions: [AlertAction] = []
    
    private init() { }
    
    func showAlert(title: String, message: String, actions: [AlertAction]) {
        self.alertTitle = title
        self.alertMessage = message
        self.alertActions = actions
        isAlertVisible = true
    }
    
    func hideAlert() { isAlertVisible = false }
}
