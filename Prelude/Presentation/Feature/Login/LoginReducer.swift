//
//  LoginFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/5/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginReducer {
    @ObservableState
    struct State {
        @Shared var session: Session
    }
    
    enum Action {
        case loginButtonTapped(LoginProvider)
        
        case loginRequest(LoginProvider)
        case loginResponse(Result<UserInfo, DomainError>)
        
        case setToast(ToastEvent)
        
        case decideNextStepAfterLogin(UserInfo)
        case navigateToInfoSetupStart
        case navigateToMain
    }
    
    @Dependency(\.authFacade) var auth
    @Dependency(\.eventBus) var eventBus
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .loginButtonTapped(let provider):
                    return .send(.loginRequest(provider))
                    
                case .loginRequest(let provider):
                    return .run { send in
                        do {
                            let result = try await auth.login(provider)
                            await send(.loginResponse(.success(result)))
                        } catch let error as DomainError { await send(.loginResponse(.failure(error))) }
                    }
                    
                case .loginResponse(.success(let userInfo)):
                    state.$session.userInfo.withLock { $0 = userInfo }
                    state.$session.isAuthenticated.withLock { $0 = true }
                    return .send(.decideNextStepAfterLogin(userInfo))
                    
                case .loginResponse(.failure(let error)):
                    return .send(.setToast(.error(error)))
                    
                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(.toast(event))
                    }
                    
                case .decideNextStepAfterLogin(let user):
                    if user.didAgreeToTermsAndConditions {
                        return .send(.navigateToMain)
                    } else { return .send(.navigateToInfoSetupStart) }
                    
                case .navigateToMain: return .none
                case .navigateToInfoSetupStart: return .none
            }
        }
    }
}
