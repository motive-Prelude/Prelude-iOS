//
//  SessionFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/5/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SessionReducer {
    @ObservableState
    struct State {
        @Shared(.inMemory("session")) var session = Session()
    }
    
    enum Action {
        case observeSessionState
        
        case restoreSessionResponse(String?)
        case fetchUserInfo(String)
        case fetchUserInfoResponse(Result<UserInfo, DomainError>)
        case delegate(Delegate)
        
        enum Delegate {
            case authStateChanged(UserInfo?)
        }
    }
    
    @Dependency(\.authFacade) var auth
    @Dependency(\.fetchUserInfoUseCase) var fetchUserInfoUseCase
    @Dependency(\.eventBus) var eventBus
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .observeSessionState:
                    return .run { send in
                        var didEmit = false
                        
                        auth.observeAuthState { id in
                            guard !didEmit else { return }
                            didEmit = true
                            Task { await send(.restoreSessionResponse(id)) }
                        }
                    }
                    
                case .restoreSessionResponse(let id):
                    if let id { return .send(.fetchUserInfo(id)) }
                    else { return .send(.delegate(.authStateChanged(nil))) }
                    
                case .fetchUserInfo(let id):
                    return .run { send in
                        do {
                            let userInfo = try await fetchUserInfoUseCase.execute(userID: id)
                            await send(.fetchUserInfoResponse(.success(userInfo)))
                        } catch let error as DomainError { await send(.fetchUserInfoResponse(.failure(error))) }
                    }
                    
                case .fetchUserInfoResponse(.success(let userInfo)):
                    return .send(.delegate(.authStateChanged(userInfo)))
                    
                case .fetchUserInfoResponse(.failure):
                    return .send(.delegate(.authStateChanged(nil)))
                    
                case .delegate:
                    return .none
            }
        }
    }
}
