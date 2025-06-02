//
//  AccountFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/16/25.
//

import AuthenticationServices
import ComposableArchitecture
import SwiftUI

@Reducer
struct AccountReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        var alert: AlertState<Action>?
    }
    
    enum ReauthenticatePurpose {
        case deleteAccount
    }
    
    enum Action {
        case deleteAccountButtonTapped
        case logoutButtonTapped
        case backButtonTapped
        
        case reauthenticate(LoginProvider)
        case reauthenticateResultResponse(Result<String, DomainError>)
        
        case logout
        case logoutResponse(Result<Void, DomainError>)
        
        case confirmDeleteAccount
        case deleteAccount(String)
        case deleteAccountResponse(Result<Void, DomainError>)
        
        
        case navigateToLogin
        
        case setToast(ToastEvent)
        indirect case setAlert(event: AlertEvent, primary: Action, secondary: Action)
        case alert(Alert)
        
        enum Alert {
            case confirmDeleteAccount
            case dismiss
        }
    }
    
    @Dependency(\.alertStateResolver) var alertStateResolver
    @Dependency(\.authFacade) var auth
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .deleteAccountButtonTapped:
                    return .send(.setAlert(
                        event: .intent(.confirmDeleteAccount),
                        primary: .alert(.confirmDeleteAccount),
                        secondary: .alert(.dismiss)))
                    
                case .confirmDeleteAccount:
                    return .send(.reauthenticate(.apple))
                    
                case .deleteAccount (let sub):
                    guard let id = state.user?.id else { return .send(.deleteAccountResponse(.failure(.userNotFound))) }
                    
                    return .run { send in
                        do {
                            try await auth.deleteAccount(id: id, sub: sub)
                            await send(.deleteAccountResponse(.success(())))
                        } catch let error as DomainError { await send(.deleteAccountResponse(.failure(error))) }
                    }
                
                case .deleteAccountResponse(.success()):
                    return .concatenate(
                        .send(.setToast(.intent(.deleteAccountCompleted))),
                        .send(.navigateToLogin)
                    )
                    
                case .deleteAccountResponse(.failure(let error)):
                    return .send(.setToast(.error(error)))
                    
                case .reauthenticate(let provider):
                    return .run { send in
                        do {
                            let sub = try await auth.reauthenticate(provider)
                            await send(.reauthenticateResultResponse(.success(sub)))
                        } catch let error as DomainError { await send(.reauthenticateResultResponse(.failure(error))) }
                    }
                    
                case .reauthenticateResultResponse(.success(let parameter)):
                    return .send(.deleteAccount(parameter))
                    
                case .reauthenticateResultResponse(.failure(let error)):
                    return .send(.setToast(.error(error)))
                    
                case .logoutButtonTapped:
                    return .send(.logout)
                    
                case .logout:
                    return .run { send in
                        do {
                            try auth.logout()
                            await send(.logoutResponse(.success(())))
                        } catch let error as DomainError { await send(.logoutResponse(.failure(error))) }
                    }
                    
                case .logoutResponse(.success):
                    return .concatenate(
                        .send(.setToast(.intent(.loggedOut))),
                        .send(.navigateToLogin)
                    )
                    
                case .logoutResponse(.failure(let error)):
                    return .send(.setToast(.error(error)))
                    
                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(.toast(event))
                    }
                    
                case let .setAlert(event, primaryAction, secondaryAction):
                    let alertState = alertStateResolver.resolve(event, primaryAction: primaryAction, secondaryAction: secondaryAction)
                    
                    state.alert = alertState
                    return .none
                    
                case .alert(.confirmDeleteAccount):
                    state.alert = nil
                    return .send(.confirmDeleteAccount)
                    
                case .alert(.dismiss):
                    state.alert = nil
                    return .none
                    
                case .backButtonTapped:
                    return .run { _ in
                        await dismiss()
                    }
                    
                case .navigateToLogin:
                    return .none
            }
        }
    }
}
