//
//  DisclaimerView.swift
//  Junction
//
//  Created by 송지혁 on 12/2/24.
//

import SwiftUI

struct DisclaimerView: View {
    @State private var healthDisclaimerToggleState = false
    @State private var privacyPolicyToggleState = false
    
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            headline
                .padding(.top, 100)
        } content: {
            disclaimerParagraph
            Spacer()
            termsAndConditionsToggle
                .padding(.bottom, 44)
                .fixedSize(horizontal: false, vertical: true)
        } buttons: { button }
        .navigationBarBackButtonHidden()
    }
    
    private var headline: some View {
        Text(Localization.Label.noticeLabel)
            .textStyle(typographies.heading2)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var disclaimerParagraph: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Localization.Label.healthDisclaimerLabel)
                .textStyle(typographies.label)
                .foregroundStyle(PLColor.neutral800)
            
            Text(Localization.Label.healthDisclaimerContent)
                .textStyle(typographies.paragraph1)
                .foregroundStyle(PLColor.neutral800)
                .fixedSize(horizontal: false, vertical: true)
                
        }
    }
    
    private var termsAndConditionsToggle: some View {
        VStack(spacing: 20) {
            HStack(spacing: 26) {
                Text(Localization.Label.healthDisclaimerAcceptance)
                    .textStyle(typographies.label)
                    .foregroundStyle(PLColor.neutral800)
                    .layoutPriority(1)
                
                Toggle(isOn: $healthDisclaimerToggleState) {
                    
                }
                
            }
            
            HStack(spacing: 26) {
                Text(Localization.Label.privacyPolicyAcceptance)
                    .textStyle(typographies.label)
                    .foregroundStyle(PLColor.neutral800)
                    .layoutPriority(1)
                
                Toggle(isOn: $privacyPolicyToggleState) {
                    
                }
            }
        }
        
    }
    
    private var button: some View {
        PLActionButton(label: Localization.Button.acceptContinueButtonTitle,
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect,
                       isDisabled: !(healthDisclaimerToggleState && privacyPolicyToggleState)) {
            Task {
                userSession.userInfo?.didAgreeToTermsAndConditions = true
                guard NetworkMonitor.shared.isConnected else {
                    EventBus.shared.errorPublisher.send(.networkUnavailable)
                    return
                }
                if await userSession.updateCurrentUser() {
                    await MainActor.run { navigationManager.navigate(.welcome) }
                }
                
            }
        }
    }
}

#Preview {
    DisclaimerView()
        .environmentObject(NavigationManager())
}
