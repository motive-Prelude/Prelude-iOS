//
//  RouterFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct RouterReducer {
    @ObservableState
    struct State {
        @Shared(.inMemory("session")) var session = Session()
        var path = StackState<Path.State>()
        
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case pushMain
        case pushLogin
        case popToMain
    }
    
    @Reducer
    enum Path {
        case login(LoginReducer)
        case healthSetupStart(InfoSetUpStartReducer)
        case healthSetup(HealthInfoSetupReducer)
        case healthConfirm(HealthInfoConfirmReducer)
        case disclaimer(DisclaimerReducer)
        case welcome(WelcomeReducer)
        case main(MainReducer)
        case setting(SettingReducer)
        case account(AccountReducer)
        case healthEdit(EditReducer)
        case result(ResultReducer)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .pushMain:
                    state.path.append(.main(MainReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .pushLogin:
                    state.path.append(.login(LoginReducer.State(session: state.$session)))
                    return .none
                    
                    
                case .path(.element(id: _, action: .login(.navigateToMain))):
                    state.path.append(.main(MainReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .login(.navigateToInfoSetupStart))):
                    state.path.append(.healthSetupStart(InfoSetUpStartReducer.State()))
                    return .none
                    
                case .path(.element(id: _, action: .healthSetupStart(.navigateTohealthInfoSetUp))):
                    state.path.append(.healthSetup(HealthInfoSetupReducer.State(user: state.$session.userInfo)))
                    return .none
                
                case .path(.element(id: _, action: .healthSetupStart(.navigateToDisclaimer))):
                    state.path.append(.disclaimer(DisclaimerReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .healthSetup(.navigateToHealthSetupConfirm(let healthInfo)))):
                    state.path.append(.healthConfirm(HealthInfoConfirmReducer.State(user: state.$session.userInfo, healthInfo: healthInfo, mode: .passive)))
                    return .none
                
                case .path(.element(id: _, action: .healthSetup(.navigateToDisclaimer))):
                    state.path.append(.disclaimer(DisclaimerReducer.State(user: state.$session.userInfo)))
                    return .none
                                
                case .path(.element(id: _, action: .healthConfirm(.navigateToDisclaimer))):
                    state.path.append(.disclaimer(DisclaimerReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .disclaimer(.navigateToMain))):
                    state.path.append(.main(MainReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .disclaimer(.navigateToWelcome))):
                    state.path.append(.welcome(WelcomeReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .welcome(.navigateToMain))):
                    state.path.append(.main(MainReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .main(.navigateToSetting))):
                    state.path.append(.setting(SettingReducer.State()))
                    return .none
                
                case .path(.element(id: _, action: .setting(.navigateToEdit))):
                    state.path.append(.healthEdit(EditReducer.State(user: state.$session.userInfo, contentMode: .active)))
                    return .none
                    
                case .path(.element(id: _, action: .setting(.navigateToAccount))):
                    state.path.append(.account(AccountReducer.State(user: state.$session.userInfo)))
                    return .none
                    
                case .path(.element(id: _, action: .main(.navigateToResult(let image, let information)))):
                    state.path.append(.result(ResultReducer.State(user: state.$session.userInfo, foodImage: image, foodInformation: information)))
                    return .none
                    
                case .path(.element(id: _, action: .result(.navigateToMain))):
                    return .none
                
                case .path(.element(id: _, action: .account(.navigateToLogin))):
                    state.path = StackState([.login(LoginReducer.State(session: state.$session))])
                    return .none
                    
                case .path:
                    return .none
                    
                case .popToMain:
                    return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
