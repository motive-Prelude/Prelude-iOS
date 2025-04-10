//
//  DeleteAccountUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/24/24.
//

import Foundation

class DeleteAccountUseCase {
    private let authRepository: AuthRepository
    private let userSyncService: UserSyncService
    
    init(authRepository: AuthRepository, userSyncService: UserSyncService) {
        self.authRepository = authRepository
        self.userSyncService = userSyncService
    }
    
    func execute(id: String, sub: String) async throws(DomainError) {
        do {
            try await authRepository.deleteAccount(id: id)
            let currentUser = try await userSyncService.fetch(id: id, from: .active)
            let deletedUser = UserInfo(id: sub, remainingTimes: 0,
                                       didAgreeToTermsAndConditions: currentUser.didAgreeToTermsAndConditions,
                                       didReceiveGift: currentUser.didReceiveGift)
            
            try await userSyncService.delete(id: id, from: .active)
            try await userSyncService.save(user: deletedUser, in: .deleted)
            
        } catch let error as RepositoryError { throw ErrorMapper.mapToDomain(error) }
        catch let error as DomainError { throw error }
        catch { throw .unknown }
    }
}
