//
//  AuthUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import Foundation

class LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    
    func execute(parameter: AuthParameter) async throws -> String {
        try await authRepository.logIn(parameters: parameter)
    }
}
