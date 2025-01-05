//
//  ReauthenticateUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import Foundation

class ReauthenticateUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(parameter: AuthParameter) async throws(DomainError) {
        do {
            try await authRepository.reauthenticate(parameter: parameter)
        } catch { throw ErrorMapper.map(error) }
    }
}
