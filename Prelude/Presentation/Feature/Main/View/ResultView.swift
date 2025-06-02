//
//  ResultView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import ComposableArchitecture
import SwiftUI


enum JudgeResult {
    case positive
    case caution
    case negative
}

struct ResultView: View {
    @Environment(\.plTypographySet) var typographies
    @Environment(\.openURL) var openURL
    
    @Bindable var store: StoreOf<ResultReducer>
    
    var body: some View {
        ZStack {
            backgroundColor
            
            if store.isLoading {
                LoadingView(currentProcedure: $store.procedure)
                    .task { store.send(.onAppear) }
            } else {
                resultView
            }
        }
        .navigationBarBackButtonHidden()
        .alert(state: store.alert) { action in store.send(action) }
    }
    
    private var backgroundColor: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var resultView: some View {
        EmptyView()
    }
    
    
}
