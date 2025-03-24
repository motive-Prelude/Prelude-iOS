//
//  SettingView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    let defaultHealthInfo = HealthInfo(id: UUID().uuidString,
                                       gestationalWeek: .noResponse,
                                       height: 0.0, weight: 0.0,
                                       lastHeightUnit: .centimeter,
                                       lastWeightUnit: .kilogram,
                                       bloodPressure: .noResponse,
                                       diabetes: .noResponse,
                                       restrictions: [])
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 32) {
            navigationHeader
        } content: {
            VStack {
                settingList
                Spacer()
            }
        } footer: { EmptyView() }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderSettingTitle) {
            PLActionButton(icon: Image(.back),
                           type: .secondary,
                           contentType: .icon,
                           size: .small,
                           shape: .square) { navigationManager.previous() }
        } trailing: { EmptyView() }
    }
    
    private var settingList: some View {
        VStack(spacing: 8) {
            PLListItem(title: Localization.NavigationHeader.navigationHeaderEditHealthInfoTitle, supportingText: "", .active) {
                guard let userInfo = userSession.userInfo else { return }
                let healthInfo = userInfo.healthInfo ?? defaultHealthInfo
                navigationManager.navigate(.healthInfoEdit(healthInfo: healthInfo, contentMode: .active))
            }
            
            PLListItem(title: Localization.NavigationHeader.navigationHeaderAccountTitle, supportingText: "", .active) {
                navigationManager.navigate(.account)
            }
        }
    }
}
