//
//  LoginFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/4/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State {
        @Shared(.inMemory("session")) var session = Session()
        var locale: Locale = .current
        
        var toast = ToastReducer.State()
        var sessionFeature = SessionReducer.State()
        var router = RouterReducer.State()
    }
    
    enum Action {
        case session(SessionReducer.Action)
        case router(RouterReducer.Action)
        case toast(ToastReducer.Action)
        
        case task
        case observeEvent
        case handleEvent(GlobalEvent)
        case restoreSession
        
        case navigateToLogin
        case navigateToMain
    }
    
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Scope(state: \.sessionFeature, action: \.session) { SessionReducer() }
        Scope(state: \.router, action: \.router) { RouterReducer() }
        Scope(state: \.toast, action: \.toast) { ToastReducer() }
        
        Reduce { state, action in
            switch action {
                case .task:
                    return .send(.observeEvent)
                    
                case .observeEvent:
                    return .run { send in
                        for await event in await eventBus.events() {
                            await send(.handleEvent(event))
                        }
                    }
                    
                case .handleEvent(let event):
                    return .run { send in
                        switch event {
                            case .toast(let event):
                                await send(.toast(.show(event)))
                        }
                    }
                    
                case .restoreSession:
                    return .send(.session(.observeSessionState))
                    
                case .session(.delegate(.authStateChanged(let user))):
                    state.$session.userInfo.withLock { $0 = user }
                    state.$session.isAuthenticated.withLock { $0 = user != nil }
                    
                    return .run { send in
                        try await clock.sleep(for: .seconds(1))
                        if user == nil { await send(.navigateToLogin) }
                        else { await send(.navigateToMain) }
                    }
                    
                    
                case .session:
                    return .none
                case .router:
                    return .none
                case .toast:
                    return .none
                case .navigateToLogin:
                    return .send(.router(.pushLogin))
                case .navigateToMain:
                    return .send(.router(.pushMain))
            }
        }
    }
}
