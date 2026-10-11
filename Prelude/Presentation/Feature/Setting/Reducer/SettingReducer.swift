//
//  SettingFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/15/25.
//

import ComposableArchitecture

@Reducer
struct SettingReducer {
    @ObservableState
    struct State {
        
    }
    
    enum Action {
        case backButtonTapped
        case editButtonTapped
        case accountButtonTapped
        
        case navigateToEdit
        case navigateToAccount
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .backButtonTapped:
                    return .run { _ in await dismiss() }
                    
                case .editButtonTapped:
                    return .send(.navigateToEdit)
                    
                case .accountButtonTapped:
                    return .send(.navigateToAccount)
                    
                case .navigateToEdit: return .none
                case .navigateToAccount: return .none
            }
        }
    }
}
