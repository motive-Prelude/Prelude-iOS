//
//  AccountView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import ComposableArchitecture
import SwiftUI

struct AccountView: View {
    @Environment(\.plTypographySet) var typographies
    @Bindable var store: StoreOf<AccountReducer>
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 20) {
            navigationHeader
        } content: {
            VStack(alignment: .leading, spacing: 32) {
                logOutSegment
                deleteAccountSegment
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } footer: { EmptyView() }
            .alert(state: store.alert, onAction: { action in store.send(action) })
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderAccountTitle) {
            PLActionButton(icon: Image(.back),
                           type: .secondary,
                           contentType: .icon,
                           size: .small,
                           shape: .square) {
                store.send(.backButtonTapped)
            }
        } trailing: { EmptyView() }
        
    }
    
    private var logOutSegment: some View {
        VStack(alignment: .leading, spacing: 0) {
            logOutButton
            logOutDescription
        }
    }
    
    private var deleteAccountSegment: some View {
        VStack(alignment: .leading, spacing: 0) {
            deleteAccountButton
            deleteAccountDescription
        }
    }
    
    private var logOutButton: some View {
        PLActionButton(label: Localization.Button.logOutButtonTitle,
                       type: .secondary,
                       contentType: .text,
                       size: .medium,
                       shape: .none) {
            store.send(.logoutButtonTapped)
            
        }
        .foregroundStyle(PLColor.neutral600)
    }
    
    private var logOutDescription: some View {
        Text(Localization.Label.logOutDescription)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
    
    private var deleteAccountButton: some View {
        PLActionButton(label: Localization.Button.deleteAccountButtonTitle,
                       type: .secondary,
                       contentType: .text,
                       size: .medium,
                       shape: .none,
                       directionalForegroundColor: PLColor.negative) {
            store.send(.deleteAccountButtonTapped)
        }
    }
    
    private var deleteAccountDescription: some View {
        Text(Localization.Label.deleteAccountDescription)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
}
