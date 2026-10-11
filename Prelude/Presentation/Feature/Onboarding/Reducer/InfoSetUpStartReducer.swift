//
//  InfoSetUpStartFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct InfoSetUpStartReducer {
    @ObservableState
    struct State {
        
    }
    
    enum Action {
        case beginButtonTapped
        case skipButtonTapped
        
        case navigateTohealthInfoSetUp
        case navigateToDisclaimer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .beginButtonTapped:
                    return .send(.navigateTohealthInfoSetUp)
                case .skipButtonTapped:
                    return .send(.navigateToDisclaimer)
                    
                case .navigateToDisclaimer:
                    return .none
                    
                case .navigateTohealthInfoSetUp:
                    return .none
                    
            }
        }
    }
}
