//
//  CustomAlertView.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import ComposableArchitecture
import SwiftUI

struct CustomAlertView<Action>: View {
    let state: AlertState<Action>
    let action: (Action) -> Void
    
    var body: some View {
        ZStack {
            background
            PLDialog(title: state.title,
                     description: state.message,
                     cancelButtonLabel: state.secondaryButton.label,
                     confirmButtonLabel: state.primaryButton.label,
                     primaryButtonType: state.primaryButton.role) {
                action(state.primaryButton.action)
            } cancelAction: {
                action(state.secondaryButton.action)
            }
        }
    }
    
    private var background: some View {
        Color.black.opacity(0.2)
            .ignoresSafeArea()
    }
}
