//
//  DisclaimerFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct DisclaimerReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        var agreedToHealthDisclaimer = false
        var agreedToPrivacyPolicy = false
    }
    
    enum Action: BindableAction {
        case acceptButtonTapped
        
        case updateUserInfo(UserInfo)
        case updateUserInfoResponse(Result<UserInfo, DomainError>)
        case updateUserInfoFailed(DomainError)
        
        case decideNextStep(UserInfo)
        
        case navigateToMain
        case navigateToWelcome
        
        
        case setToast(GlobalEvent)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.networkMonitor) var network
    @Dependency(\.updateUserInfoUseCase) var updateUserInfoUseCase
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .acceptButtonTapped:
                    guard network.isConnected else { return .send(.updateUserInfoResponse(.failure(.networkUnavailable))) }
                    guard let user = state.user else { return .send(.updateUserInfoResponse(.failure(.authenticationFailed))) }
                    
                    return .send(.updateUserInfo(user))
                    
                    
                case .updateUserInfo(let user):
                    return .run { send in
                        do {
                            user.didAgreeToTermsAndConditions = true
                            let updatedUserInfo = try await updateUserInfoUseCase.execute(userInfo: user)
                            await send(.updateUserInfoResponse(.success(updatedUserInfo)))
                        } catch let error as DomainError {
                            await send(.updateUserInfoResponse(.failure(error)))
                        }
                    }
                    
                case .updateUserInfoResponse(.success(let user)):
                    state.$user.withLock { $0 = user }
                    return .send(.decideNextStep(user))
                    
                case .updateUserInfoResponse(.failure(let error)):
                    return .send(.updateUserInfoFailed(error))
                    
                case .decideNextStep(let user):
                    if user.didReceiveGift { return .send(.navigateToMain) }
                    else { return .send(.navigateToWelcome) }
                    
                case .navigateToMain:
                    return .none
                
                case .navigateToWelcome:
                    return .none
                
                case .updateUserInfoFailed(let error):
                    return .send(.setToast(.toast(.error(error))))
                
                case .binding(_):
                    return .none
                    
                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(event)
                    }
            }
        }
    }
}
