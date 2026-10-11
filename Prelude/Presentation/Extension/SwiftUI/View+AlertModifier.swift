//
//  View+.swift
//  Prelude
//
//  Created by 송지혁 on 5/24/25.
//

import SwiftUI

extension View {
    func alert<Action>(state: AlertState<Action>?, onAction: @escaping (Action) -> Void) -> some View {
        self.modifier(AlertModifier(state: state, action: onAction))
    }
}
