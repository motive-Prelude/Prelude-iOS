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
            
        } catch let error as AuthError { throw parseError(error) }
        catch let error as DomainError { throw error }
        catch { throw .unknown }
    }
    
    private func parseError(_ error: AuthError) -> DomainError {
        switch error {
            case .networkError: return .networkUnavailable
            case .invalidCredential: return .authenticationFailed(reason: "잘못된 사용자 정보입니다.")
            case .sessionExpired: return .authenticationFailed(reason: "너무 오랜 시간이 걸렸어요.")
            case .tooManyRequests: return .authenticationFailed(reason: "너무 많은 시도를 했어요.")
            case .userDisabled: return .authenticationFailed(reason: "정지된 사용자에요.")
            case .userMismatch: return .authenticationFailed(reason: "다른 사용자의 로그인이 감지됐어요.")
            case .userNotFound: return .authenticationFailed(reason: "사용자 정보를 찾을 수 없어요.")
            default: return .unknown
                
        }
    }
}
