//
//  FirebaseAuthError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//

enum AuthError: Error {
    case networkError
    case sessionExpired
    case invalidCredential
    case userDisabled
    case userNotFound
    case userMismatch
    case tooManyRequests
    case unknown
}
