//
//  AlertModifier.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

import SwiftUI

struct AlertModifier<Action>: ViewModifier {
    let state: AlertState<Action>?
    let action: (Action) -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let state { CustomAlertView(state: state, action: action) }
        }
    }
}
