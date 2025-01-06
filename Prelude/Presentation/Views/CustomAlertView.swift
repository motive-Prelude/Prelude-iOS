//
//  CustomAlertView.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        ZStack {
            background
                
            PLDialog(title: alertManager.title,
                     description: alertManager.message,
                     cancelButtonLabel: alertManager.actions[0].title,
                     confirmButtonLabel: alertManager.actions[1].title,
                     primaryColor: alertManager.actions[1].directionalColor,
                     secondaryColor: alertManager.actions[0].directionalColor) {
                alertManager.actions[1].action()
                alertManager.hideAlert()
            } cancelAction: {
                alertManager.actions[0].action()
                alertManager.hideAlert()
            }
        }
        .animation(.linear, value: alertManager.isAlertVisible)
    }
    
    private var background: some View {
        Color.black.opacity(0.2)
            .ignoresSafeArea()
    }
}

#Preview {
    CustomAlertView()
}
