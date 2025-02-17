//
//  WelcomeView.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.plTypographySet) var typographies

    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 16) {
            navigationHeader
        } content: {
            VStack {
                welcomeGift
                Spacer()
            }
        } footer: {
            startButton
        }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) { navigationManager.previous() }
        } trailing: { EmptyView() }
    }
    
    private var welcomeGift: some View {
        VStack(spacing: 24) {
            Text(Localization.Label.welcomeGiftTitle)
                .textStyle(typographies.heading1)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(.welcomeGift)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(Localization.Label.welcomeGiftContent)
            .textStyle(typographies.paragraph1)
            .foregroundStyle(PLColor.neutral700)
            .lineLimit(8)
            .minimumScaleFactor(0.1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var startButton: some View {
        PLActionButton(label: Localization.Button.receiveGiftButtonTitle, type: .primary, contentType: .text, size: .large, shape: .rect) {
            Task {
                guard NetworkMonitor.shared.isConnected else {
                    EventBus.shared.errorPublisher.send(.networkUnavailable)
                    return
                }
                
                if !userSession.hasReceiveGift { try await userSession.giveGift() }
                navigationManager.navigate(.main)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
