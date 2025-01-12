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
    
    @Environment(\.openURL) var openURL
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
                linkedText(Localization.Label.healthDisclaimerAcceptance, url: "https://kind-push-1b8.notion.site/Health-Disclaimer-16c73460715e80e49f0efc541c57aff3?pvs=4")
                    .layoutPriority(1)
                
                Toggle(isOn: $healthDisclaimerToggleState) {
                    
                }
                
            }
            
            HStack(spacing: 26) {
                linkedText(Localization.Label.privacyPolicyAcceptance, url: "https://kind-push-1b8.notion.site/Privacy-Policy-16173460715e80629d45cb61058a3e8c?pvs=4")
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
                    await MainActor.run { navigationManager.navigate(userSession.hasReceiveGift ? .main : .welcome) }
                }
                
            }
        }   
    }
    
    private func linkedText(_ text: String, url: String) -> some View {
        let components = text.components(separatedBy: "__")
        
        var firstPart = AttributedString(components[0])
        firstPart.font = typographies.paragraph1.font
        firstPart.foregroundColor = PLColor.neutral800
        
        var linkPart = AttributedString(components[1])
        linkPart.font = typographies.label.font
        linkPart.foregroundColor = PLColor.neutral800
        linkPart.underlineStyle = .single
        linkPart.link = URL(string: url)
        
        var lastPart = AttributedString(components[2])
        lastPart.font = typographies.paragraph1.font
        lastPart.foregroundColor = PLColor.neutral800
        
        var attributedText = firstPart
        attributedText.append(linkPart)
        attributedText.append(lastPart)
        
        return Text(attributedText).lineSpacing(6)

    }
}

#Preview {
    DisclaimerView()
        .environmentObject(NavigationManager())
}
