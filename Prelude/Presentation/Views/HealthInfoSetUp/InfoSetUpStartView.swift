//
//  InfoSetUpStartView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import SwiftUI

struct InfoSetUpStartView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var alertManager: AlertManager
    
    var primaryAlertAction: AlertAction {
        AlertAction(title: "Enter Info", action: { navigationManager.navigate(.healthInfoSetup) })
    }
    var secondaryAlertAction: AlertAction {
        AlertAction(title: "Skip", action: { navigationManager.navigate(.disclaimer) })
    }
    
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            navigationHeader
        } content: {
            VStack {
                content
                Spacer()
            }
        } buttons: {
            VStack(spacing: 8) {
                startButton
                skipButton
            }
        }

    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") { EmptyView() }
        trailing: { EmptyView() }
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            Text("Let’s get to know your\nhealth needs")
                .textStyle(.heading1)
                .foregroundStyle(PLColor.neutral800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Image(.clipboardIllust)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            Text("To provide you with the best experience, we use your health information to deliver accurate and personalized food safety tips customized for your needs.")
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral700)
        }
    }
    
    private var startButton: some View {
        PLActionButton(label: "Begin", type: .primary, contentType: .text, size: .large, shape: .rect) {
            navigationManager.navigate(.healthInfoSetup)
        }
    }
    
    private var skipButton: some View {
        PLActionButton(label: "Skip", type: .secondary, contentType: .text, size: .medium, shape: .none) {
            alertManager.showAlert(title: "Are you sure you want to skip?",
                                   message: "This information is essential for accurate results.",
                                   actions: [secondaryAlertAction, primaryAlertAction])
        }
    }
}

#Preview {
    InfoSetUpStartView()
}
