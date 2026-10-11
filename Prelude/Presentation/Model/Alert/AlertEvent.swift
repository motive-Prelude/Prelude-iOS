//
//  AlertEvent.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


enum AlertEvent {
    case intent(AlertIntent)
    case error(DomainError)
}