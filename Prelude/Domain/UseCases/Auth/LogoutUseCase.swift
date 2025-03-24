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
    
    
    func execute() throws(DomainError) {
        do { try authRepository.logOut() }
        catch { throw parseError(error) }
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

