//
//  AlertState.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

struct AlertState<Action> {
    let title: String
    let message: String
    let primaryButton: AlertButton<Action>
    let secondaryButton: AlertButton<Action>
}
