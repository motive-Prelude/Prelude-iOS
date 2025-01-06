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
    
    var secondaryAlertAction: AlertAction {
        AlertAction(title: "Cancel") { alertManager.hideAlert() }
    }
    
    var primaryAlertAction: AlertAction {
        AlertAction(title: "Delete", directionalColor: PLColor.negative) {
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
        } buttons: { EmptyView() }
        
        
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("Account") {
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
        PLActionButton(label: "Log out", type: .secondary, contentType: .text, size: .medium, shape: .none) {
            userSession.logout { navigationManager.screenPath = [.content] }
        }
        .foregroundStyle(PLColor.neutral600)
    }
    
    private var logOutDescription: some View {
        Text("When you log out, your data will remain on your device until you delete your app.")
            .textStyle(.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
    
    private var deleteAccountButton: some View {
        PLActionButton(label: "Delete Account", type: .secondary, contentType: .text, size: .medium, shape: .none, directionalForegroundColor: PLColor.negative) {
            alertManager.showAlert(title: "Delete Account?",
                                   message: "This action cannot be undone. It will permanently delete your entire account, including purchased seeds.",
                                   actions: [secondaryAlertAction, primaryAlertAction])
        }
    }
    
    private var deleteAccountDescription: some View {
        Text("When you delete your account, all of your data will be deleted.")
            .textStyle(.paragraph2)
            .foregroundStyle(PLColor.neutral600)
    }
}
