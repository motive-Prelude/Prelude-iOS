//
//  ToastIntent.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


enum ToastIntent {
    case loggedOut
    case saveCompleted
    case saveFailed
    case deleteAccountCompleted
    case purchaseCompleted(Int)
}