//
//  LogoutUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/24/24.
//

import Foundation

class LogOutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    
    func execute() throws {
        try authRepository.logout()
    }
}

