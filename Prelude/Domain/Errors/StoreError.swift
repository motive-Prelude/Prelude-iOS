//
//  StoreError.swift
//  Junction
//
//  Created by 송지혁 on 10/7/24.
//

enum DomainError: Error {
    case authenticationFailed(reason: String)
    case networkUnavailable
    case timeout
    case serverError
    case tooManyRequests
    case unknown
}

enum StoreError: Error {
    case failedVerification
    case insufficientFunds
    case networkUnavailable
    case unknownError
}
