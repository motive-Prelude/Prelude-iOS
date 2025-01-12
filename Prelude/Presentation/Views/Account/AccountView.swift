//
//  AccountView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var alertManager: AlertManager
    @Environment(\.plTypographySet) var typographies
    
    
    var secondaryAlertAction: AlertAction {
        AlertAction(title: Localization.Button.cancelButtonTitle) { alertManager.hideAlert() }
    }
    
    var primaryAlertAction: AlertAction {
        AlertAction(title: Localization.Button.deleteButtonTitle, directionalColor: PLColor.negative) {
            Task {
                let reauthResult = await userSession.reauthenticate(.apple)
                
                if reauthResult {
                    await userSession.deleteAccount() {
                        navigationManager.screenPath = [.content]
                        alertManager.hideAlert()
                    }
                }
            }
        }
    }
    
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
            
        } buttons: { EmptyView() }
            .trackScreen(screenName: "계정 뷰")
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderAccountTitle) {
            PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) {
                navigationManager.previous()
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
        PLActionButton(label: Localization.Button.logOutButtonTitle, type: .secondary, contentType: .text, size: .medium, shape: .none) {
            userSession.logout { navigationManager.screenPath = [.content] }
        }
        .foregroundStyle(PLColor.neutral600)
    }
    
    private var logOutDescription: some View {
        Text(Localization.Label.logOutDescription)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
    
    private var deleteAccountButton: some View {
        PLActionButton(label: Localization.Button.deleteAccountButtonTitle, type: .secondary, contentType: .text, size: .medium, shape: .none, directionalForegroundColor: PLColor.negative) {
            alertManager.showAlert(title: Localization.Dialog.dialogDeleteAccountTitle,
                                   message: Localization.Dialog.dialogDeleteAccountDescription,
                                   actions: [secondaryAlertAction, primaryAlertAction])
        }
    }
    
    private var deleteAccountDescription: some View {
        Text(Localization.Label.deleteAccountDescription)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
}
