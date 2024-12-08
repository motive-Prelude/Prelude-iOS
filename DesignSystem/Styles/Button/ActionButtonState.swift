//
//  State.swift
//  Junction
//
//  Created by 송지혁 on 11/28/24.
//


enum ActionButtonState: Hashable {
    case enabled
    case pressed
    case disabled
}

enum FormButtonState: Hashable {
    case idle
    case selected
}
