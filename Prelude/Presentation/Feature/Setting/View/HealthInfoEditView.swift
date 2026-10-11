//
//  HealthInfoEditView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import ComposableArchitecture
import SwiftUI

struct HealthInfoEditView: View {
    @Bindable var store: StoreOf<EditReducer>
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            navigationHeader
        } content: {
            VStack {
                HealthInfoListView(healthInfo: store.healthInfo, mode: store.contentMode) { keyPath in
                    store.send(.itemTapped(keyPath))
                }
                Spacer()
            }
        } footer: { EmptyView() }
            .sheet(item: $store.scope(state: \.destination?.editSheet, action: \.destination.editSheet)) { _ in
                if let keyPath = store.selectedKeyPath {
                    HealthInfoItemEditSheet(healthInfo: store.healthInfo, selectedKeyPath: keyPath)
                        .presentationCornerRadius(24)
                        .presentationDetents([.fraction(sheetHeight(keyPath))])
                        .interactiveDismissDisabled(true)
                }
            }
    }
    
    private func sheetHeight(_ keyPath: PartialKeyPath<HealthInfo>) -> CGFloat {
        switch keyPath {
            case \.restrictions, \.gestationalWeek: return 0.47
            default: return 0.4
        }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderEditHealthInfoTitle) {
            PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) { store.send(.backButtonTapped) }
        } trailing: { EmptyView() }

    }
}

