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
    
    func execute(parameter: AuthParameter) async throws(DomainError) -> String {
        do {
            let sub = try await authRepository.reauthenticate(parameter: parameter)
            return sub
        } catch { throw ErrorMapper.map(error) }
    }
}
