//
//  HealthInfoConfirmationView.swift
//  Junction
//
//  Created by 송지혁 on 12/2/24.
//

import SwiftUI

struct HealthInfoConfirmView: View {
    let healthInfo: HealthInfo
    let mode: ListItemType
    
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    @Environment(\.plTypographySet) var typographies
    
    
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            headline
                .padding(.top, 100)
        } content: {
            VStack(spacing: 0) {
                HealthInfoListView(healthInfo: healthInfo, mode: mode)
                Spacer()
            }
        } footer: { buttonGroup }
        .navigationBarBackButtonHidden()
    }
    
    private var headline: some View {
        VStack(spacing: 8) {
            Text(Localization.Label.confirmTitle)
                .textStyle(typographies.heading2)
                .foregroundStyle(PLColor.neutral800)
            
            Text(Localization.Label.confirmSubtitle)
                .textStyle(typographies.paragraph1)
                .foregroundStyle(PLColor.neutral600)
        }
    }
    
    private var buttonGroup: some View {
        HStack(spacing: 12) {
            PLActionButton(label: Localization.Button.changeButtonTitle,
                           type: .secondary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) { navigationManager.previous() }
            
            PLActionButton(label: Localization.Button.confirmButtonTitle,
                           type: .primary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) {
                userSession.userInfo?.healthInfo = healthInfo
                
                
                Task {
                    guard NetworkMonitor.shared.isConnected else {
                        EventBus.shared.errorPublisher.send(.networkUnavailable)
                        return
                    }
                    
                    if await userSession.updateCurrentUser() {
                        await MainActor.run { navigationManager.navigate(.disclaimer) }
                    }
                }
                
                
                
            }
        }
    }
}

#Preview {
    let healthInfo = HealthInfo(id: "",
                                gestationalWeek: .mid,
                                height: 123,
                                weight: 32,
                                lastHeightUnit: .centimeter,
                                lastWeightUnit: .kilogram,
                                bloodPressure: .hypotension,
                                diabetes: .type1,
                                restrictions: [.diary, .eggs, .fish, .shellfish, .treeNuts, .peanuts, .wheat, .soy, .gluten])
    
    HealthInfoConfirmView(healthInfo: healthInfo, mode: .passive)
        .environmentObject(NavigationManager())
}
