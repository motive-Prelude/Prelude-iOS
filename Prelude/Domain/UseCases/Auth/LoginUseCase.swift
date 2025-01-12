//
//  AuthUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import Foundation

class LoginUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init(authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    
    func execute(parameter: AuthParameter) async throws(DomainError) -> UserInfo {
        do {
            let (userID, sub) = try await authRepository.logIn(parameter: parameter)
            let deletedUser = await userRepository.checkRejoinUser(from: sub)
            
            if let deletedUser {
                let rejoinUser = UserInfo(id: userID, remainingTimes: 0, didReceiveGift: deletedUser.didReceiveGift)
                try await userRepository.create(collection: "User", user: rejoinUser)
                try await userRepository.delete(collection: "Deleted User", userID: sub)
                
                return rejoinUser
            } else {
                let userInfo = try await userRepository.fetch(collection: "User", userID: userID)
                
                return userInfo
            }
        }
        catch let error as AuthError { throw parseError(error) }
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
