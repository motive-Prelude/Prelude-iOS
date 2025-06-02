//
//  EditFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/16/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct EditReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        var contentMode: ListItemType
        var selectedKeyPath: PartialKeyPath<HealthInfo>?
        @Presents var destination: Destination.State?
        
        var healthInfo: HealthInfo
        
        init(user: Shared<UserInfo?>, contentMode: ListItemType) {
            self._user = user
            self.contentMode = contentMode
            
            self.healthInfo = user.wrappedValue?.healthInfo ?? HealthInfo(
                    id: UUID().uuidString,
                    gestationalWeek: .noResponse,
                    height: 0.0,
                    weight: 0.0,
                    lastHeightUnit: .centimeter,
                    lastWeightUnit: .kilogram,
                    bloodPressure: .noResponse,
                    diabetes: .noResponse,
                    restrictions: []
                )
        }
        
    }
    
    enum Action: BindableAction {
        case backButtonTapped
        
        case binding(BindingAction<State>)
        case itemTapped(PartialKeyPath<HealthInfo>)
        case destination(PresentationAction<Destination.Action>)
        
        case updateUserInfo(UserInfo)
        case updateUserInfoResponse(Result<Void, DomainError>)
        
        case setToast(ToastEvent)
        
    }
    
    @Reducer
    enum Destination {
        case editSheet
    }
    
    @Dependency(\.saveUserInfoUseCase) var saveUserInfoUseCase
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .backButtonTapped:
                    guard let user = state.user else { return .send(.setToast(.intent(.saveFailed))) }
                    return .send(.updateUserInfo(user))
                    
                case .itemTapped(let keyPath):
                    state.selectedKeyPath = keyPath
                    state.destination = .editSheet
                    return .none
                
                case .updateUserInfo(let user):
                    user.healthInfo = state.healthInfo
                    
                    return .run { send in
                        do {
                            try await saveUserInfoUseCase.execute(userInfo: user)
                            await send(.setToast(.intent(.saveCompleted)))
                            await send(.updateUserInfoResponse(.success(())))
                        } catch let error as DomainError {
                            await send(.updateUserInfoResponse(.failure(error)))
                        }
                    }
                    
                case .updateUserInfoResponse(.success):
                    return .run { _ in await dismiss() }
                    
                case .updateUserInfoResponse(.failure(let error)):
                    return .merge(
                        .send(.setToast(.error(error))),
                        .run { _ in await dismiss() }
                    )
                
                case .binding:
                    return .none
                    
                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(.toast(event))
                    }
                case .destination:
                    return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
