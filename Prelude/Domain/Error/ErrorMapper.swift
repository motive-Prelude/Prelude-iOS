//
//  ErrorMapper.swift
//  Junction
//
//  Created by 송지혁 on 1/3/25.
//

enum ErrorMapper {
    
    static func mapToRepository(_ error: AuthError) -> RepositoryError {
        switch error {
            case .userMismatch, .sessionExpired, .userNotFound, .invalidCredential: return .invalidCredential
            case .networkError: return .networkError
            case .tooManyRequests: return .conflict
            default: return .unknownError
        }
    }
    
    static func mapToRepository(_ error: DataSourceError) -> RepositoryError {
        switch error {
            case .permissionDenied, .unauthenticated: return .invalidCredential
            case .deadlineExceeded, .timeout, .tooManyRequests: return .timeout
            case .networkUnavailable: return .networkError
            case .notFound: return .cloudDataNotFound
            default: return .unknownError
        }
    }
    
    static func mapToRepository(_ error: APIError) -> RepositoryError {
        switch error {
            case .timeout: return .timeout
            case .networkError: return .networkError
            default: return .unknownError
        }
    }
    
    static func mapToDomain(_ error: RepositoryError) -> DomainError {
        switch error {
            case .cloudDataNotFound, .localDataNotFound: return .userNotFound
            case .networkError: return .networkUnavailable
            case .dataParsingError, .timeout: return .serverError
            case .invalidCredential: return .authenticationFailed
            default: return .unknown
        }
    }
}
