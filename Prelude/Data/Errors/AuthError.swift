//
//  FirebaseAuthError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//

import FirebaseAuth

enum AuthError: Error {
    case networkError
    case sessionExpired
    case invalidCredential
    case userDisabled
    case userNotFound
    case userMismatch
    case tooManyRequests
    case unknown
    
    init(from error: AuthErrorCode) {
        switch error {
            case .accountExistsWithDifferentCredential: self = .invalidCredential
            case .credentialAlreadyInUse: self = .invalidCredential
            case .invalidCredential: self = .invalidCredential
            case .networkError: self = .networkError
            case .tooManyRequests: self = .tooManyRequests
            case .sessionExpired: self = .sessionExpired
            case .userDisabled: self = .userDisabled
            case .userNotFound: self = .userNotFound
            case .userMismatch: self = .userMismatch
            default: self = .unknown
            
        }
    }
}
