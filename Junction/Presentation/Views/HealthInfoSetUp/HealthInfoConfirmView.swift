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
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            headline
                .padding(.top, 100)
        } content: {
            HealthInfoListView(healthInfo: healthInfo, mode: mode)
            Spacer()
        } buttons: { buttonGroup }
        .navigationBarBackButtonHidden()
    }
    
    private var headline: some View {
        VStack(spacing: 8) {
            Text("Is this correct?")
                .textStyle(.heading2)
                .foregroundStyle(PLColor.neutral800)
            
            Text("You can edit your health data anytime.")
                .textStyle(.paragraph1)
                .foregroundStyle(PLColor.neutral600)
        }
    }
    
    private var buttonGroup: some View {
        HStack(spacing: 12) {
            PLActionButton(label: "Make changes",
                           type: .secondary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) { navigationManager.previous() }
            
            PLActionButton(label: "All good",
                           type: .primary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) {
                userSession.userInfo?.healthInfo = healthInfo
                Task { await userSession.updateCurrentUser() }
                navigationManager.navigate(.disclaimer)
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
