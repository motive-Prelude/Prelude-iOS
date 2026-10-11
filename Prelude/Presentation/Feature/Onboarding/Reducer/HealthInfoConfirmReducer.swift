//
//  HealthInfoConfirmFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct HealthInfoConfirmReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        let healthInfo: HealthInfo
        let mode: ListItemType
    }
    
    enum Action {
        case backButtonTapped
        case confirmButtonTapped
        
        case updateUserInfo
        case updateUserInfoResponse(Result<UserInfo, DomainError>)
        case updateUserInfoFailed(DomainError)
        
        case navigateToDisclaimer
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.networkMonitor) var network
    @Dependency(\.updateUserInfoUseCase) var updateUserInfoUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .confirmButtonTapped:
                    return .send(.updateUserInfo)
                
                case .backButtonTapped:
                    return .run { _ in await dismiss() }
                    
                case .updateUserInfo:
                    guard network.isConnected else { return .send(.updateUserInfoResponse(.failure(.networkUnavailable))) }
                    guard let user = state.user else { return .send(.updateUserInfoResponse(.failure(.authenticationFailed))) }
                    user.healthInfo = state.healthInfo

                    return .run { send in
                        do {
                            let updatedUser = try await updateUserInfoUseCase.execute(userInfo: user)
                            await send(.updateUserInfoResponse(.success(updatedUser)))
                        } catch let error as DomainError { await send(.updateUserInfoResponse(.failure(error))) }
                    }
                
                case .updateUserInfoResponse(.success(let user)):
                    state.$user.withLock { $0 = user }
                    return .send(.navigateToDisclaimer)
                    
                case .updateUserInfoResponse(.failure(let error)):
                    return .send(.updateUserInfoFailed(error))
                
                case .updateUserInfoFailed(let error):
                    return .run { _ in
                        await eventBus.send(.toast(.error(error)))
                    }
                
                case .navigateToDisclaimer:
                    return .none
            }
        }
    }
}
