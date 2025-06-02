//
//  StoreError.swift
//  Junction
//
//  Created by 송지혁 on 10/7/24.
//

enum DomainError: Error, Equatable {
    case authenticationFailed
    case networkUnavailable
    case timeout
    case serverError
    case userNotFound
    case tooManyRequests
    case invalidArgument
    case insufficientCurrency
    case unknown
}
