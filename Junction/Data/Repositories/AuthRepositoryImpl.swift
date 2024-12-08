//
//  AuthRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import FirebaseAuth
import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let authService: FirebaseAuthService
    
    init(authService: FirebaseAuthService) {
        self.authService = authService
    }
    
    func logIn(parameters: AuthParameter) async throws {
        guard let credential = AuthCredentialMapper.map(parameter: parameters) else { return }
        try await authService.logIn(credential: credential)
    }
    
}
