//
//  SettingView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import ComposableArchitecture
import SwiftUI

struct SettingView: View {
    let store: StoreOf<SettingReducer>
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 32) {
            navigationHeader
        } content: {
            VStack {
                settingList
                Spacer()
            }
        } footer: { EmptyView() }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderSettingTitle) {
            PLActionButton(icon: Image(.back),
                           type: .secondary,
                           contentType: .icon,
                           size: .small,
                           shape: .square) { store.send(.backButtonTapped) }
        } trailing: { EmptyView() }
    }
    
    private var settingList: some View {
        VStack(spacing: 8) {
            PLListItem(title: Localization.NavigationHeader.navigationHeaderEditHealthInfoTitle, supportingText: "", .active) { store.send(.editButtonTapped) }
            PLListItem(title: Localization.NavigationHeader.navigationHeaderAccountTitle, supportingText: "", .active) { store.send(.accountButtonTapped) }
        }
    }
}
