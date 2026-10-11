//
//  WelcomeFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct WelcomeReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
    }
    
    enum Action {
        case receiveGiftButtonTapped
        case receiveGiftResponse(Result<UserInfo, DomainError>)
        
        case setToast(GlobalEvent)
        case navigateToMain
    }
    
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.networkMonitor) var network
    @Dependency(\.addCurrencyUseCase) var addCurrencyUseCase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .receiveGiftButtonTapped:
                    guard network.isConnected else { return .send(.receiveGiftResponse(.failure(.networkUnavailable))) }
                    guard let id = state.user?.id else { return .send(.receiveGiftResponse(.failure(.userNotFound))) }
                    
                    return .run { send in
                        do {
                            let updatedUserInfo = try await addCurrencyUseCase.execute(id: id, amount: 3)
                            await send(.receiveGiftResponse(.success(updatedUserInfo)))
                        } catch let error as DomainError { await send(.receiveGiftResponse(.failure(error))) }
                    }
                    
                case .receiveGiftResponse(.success(let userInfo)):
                    state.$user.withLock { $0 = userInfo }
                    return .send(.navigateToMain)
                    
                case .receiveGiftResponse(.failure(let error)):
                    return .send(.setToast(.toast(.error(error))))
                    
                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(event)
                    }
                    
                case .navigateToMain:
                    return .none
            }
        }
    }
}
