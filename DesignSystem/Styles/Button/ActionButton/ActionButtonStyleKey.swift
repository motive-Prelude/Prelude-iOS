//
//  ButtonStyleKey.swift
//  Junction
//
//  Created by 송지혁 on 11/29/24.
//

struct ActionButtonStyleKey: Hashable, Equatable {
    let type: ButtonType
    let size: ButtonSize
    let shape: ButtonShape
    let contentType: ActionButtonContent
    let state: ActionButtonState
}
