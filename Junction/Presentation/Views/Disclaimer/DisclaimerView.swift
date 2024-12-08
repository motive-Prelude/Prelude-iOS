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
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        InfoStepTemplate(backgroundColor: PLColor.neutral50) {
            headline
                .padding(.top, 100)
        } content: {
            disclaimerParagraph
            Spacer()
            termsAndConditionsToggle
                .padding(.bottom, 44)
                .fixedSize(horizontal: false, vertical: true)
        } buttons: {
            button
        }
        .navigationBarBackButtonHidden()
    }
    
    private var headline: some View {
        Text("Notice")
            .textStyle(.heading2)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var disclaimerParagraph: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Disclaimer")
                .textStyle(.label)
                .foregroundStyle(PLColor.neutral800)
            
            Text("The information provided by Prelude is intended for general informational purposes only and is not a substitute for professional medical advice. Always consult with a qualified health professional or your healthcare provider before making any decisions related to your health, diet, or nutrition, especially during pregnancy. Individual health needs may vary, and only a healthcare professional can provide personalized advice tailored to your specific circumstances.")
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral800)
                .fixedSize(horizontal: false, vertical: true)
                
        }
        
    }
    
    private var termsAndConditionsToggle: some View {
        VStack(spacing: 20) {
            HStack(spacing: 26) {
                Text("I acknowledge and accept the terms of the Health Disclaimer")
                    .textStyle(.label)
                    .foregroundStyle(PLColor.neutral800)
                    .layoutPriority(1)
                
                Toggle(isOn: $healthDisclaimerToggleState) {
                    
                }
                
            }
            
            HStack(spacing: 26) {
                Text("I agree to the Privacy Policy, Terms of Use and Terms of Service")
                    .textStyle(.label)
                    .foregroundStyle(PLColor.neutral800)
                    .layoutPriority(1)
                
                Toggle(isOn: $privacyPolicyToggleState) {
                    
                }
            }
        }
        
    }
    
    private var button: some View {
        PLActionButton(label: "Accept and continue",
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect,
                       isDisabled: !(healthDisclaimerToggleState && privacyPolicyToggleState)) {
            navigationManager.navigate(.healthInfoSetup)
        }
    }
}

#Preview {
    DisclaimerView()
        .environmentObject(NavigationManager())
}
