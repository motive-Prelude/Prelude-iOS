//
//  ToastFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/22/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ToastReducer {
    @ObservableState
    struct State {
        var isVisible = false
        var message = ""
        var icon: Image?
        
        fileprivate var toastAnimation: Animation { .bouncy(duration: 0.4, extraBounce: 0.1) }
    }
    
    enum Action: BindableAction {
        case show(ToastEvent)
        case hide
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .show(let event):
                    withAnimation(state.toastAnimation) {
                        state.message = event.message
                        state.icon = event.icon
                        state.isVisible = true
                    }
                    
                    return .run { send in
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        await send(.hide)
                    }
                    
                case .hide:
                    withAnimation(state.toastAnimation) {
                        state.isVisible = false
                        state.message = ""
                        state.icon = nil
                    }
                    
                    return .none
                    
                case .binding:
                    return .none
                    
            }
        }
    }
}
