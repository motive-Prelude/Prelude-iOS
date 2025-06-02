//
//  AuthUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import Foundation

class LoginUseCase {
    private let authRepository: AuthRepository
    private let userSyncService: UserSyncService
    
    init(authRepository: AuthRepository, userSyncService: UserSyncService) {
        self.authRepository = authRepository
        self.userSyncService = userSyncService
    }
    
    
    func execute(parameter: AuthParameter) async throws(DomainError) -> UserInfo {
        do {
            let (userID, sub) = try await authRepository.logIn(parameter: parameter)
            let deletedUser = await userSyncService.checkRejoinUser(id: sub)
            
            if deletedUser != nil {
                let rejoinUser = UserInfo(id: userID, remainingTimes: 0, didReceiveGift: true)
                try await userSyncService.save(user: rejoinUser, in: .active)
                try await userSyncService.delete(id: sub, from: .deleted)
                
                return rejoinUser
            } else {
                if let existingUser = try? await userSyncService.fetch(id: userID, from: .active) {
                    return existingUser
                } else {
                    let newUser = UserInfo(id: userID, remainingTimes: 0, didReceiveGift: false)
                    try await userSyncService.save(user: newUser, in: .active)
                    return newUser
                }
            }
        }
        catch let error as RepositoryError { throw ErrorMapper.mapToDomain(error) }
        catch let error as DomainError { throw error }
        catch { throw .unknown }
    }
    
}
