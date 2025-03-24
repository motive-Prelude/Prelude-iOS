//
//  ErrorMapper.swift
//  Junction
//
//  Created by 송지혁 on 1/3/25.
//

import Foundation

final class ErrorMapper {
    private init() { }
    
    static func map(_ error: APIError) -> DomainError {
        switch error {
            case .networkError: return .networkUnavailable
            case .timeout: return .timeout
            case .serverError: return .serverError
            default: return .unknown
        }
    }
    
    static func map(_ error: DataSourceError) -> DomainError {
        switch error {
            case .networkUnavailable: return .networkUnavailable
            case .unauthenticated: return .authenticationFailed(reason: "인증 실패")
            case .notFound: return .authenticationFailed(reason: "유저를 찾을 수 없음")
            case .timeout: return .timeout
            case .tooManyRequests: return .tooManyRequests
            default: return .unknown
        }
    }
    
    static func map(_ error: AuthError) -> DomainError {
        switch error {
            case .networkError: return .networkUnavailable
            case .invalidCredential: return .authenticationFailed(reason: "인증 실패")
            case .userDisabled: return .authenticationFailed(reason: "제한된 사용자")
            case .sessionExpired: return .authenticationFailed(reason: "시간 초과")
            case .tooManyRequests: return .authenticationFailed(reason: "너무 많은 시도")
            default: return .unknown
            
        }
    }
    
}
