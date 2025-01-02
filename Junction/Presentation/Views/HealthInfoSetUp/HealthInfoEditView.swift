//
//  HealthInfoEditView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import SwiftUI

struct HealthInfoEditView: View {
    let healthInfo: HealthInfo
    let mode: ListItemType
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    @State private var selectedKeyPath: PartialKeyPath<HealthInfo>? = nil
    @State private var isSheetPresented = false
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            navigationHeader
        } content: {
            VStack {
                HealthInfoListView(healthInfo: healthInfo, mode: mode) { keyPath in
                    selectedKeyPath = keyPath
                }
                Spacer()
            }
        } buttons: { EmptyView() }
            .onChange(of: selectedKeyPath) { _, _ in
                if selectedKeyPath != nil { isSheetPresented = true }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: { selectedKeyPath = nil }) {
                if let keyPath = selectedKeyPath {
                    HealthInfoItemEditSheet(healthInfo: healthInfo, selectedKeyPath: keyPath)
                        .presentationCornerRadius(24)
                        .presentationDetents([.fraction(sheetHeight(keyPath))])
                        .interactiveDismissDisabled(true)
                }
                    
            }
    }
    
    private func sheetHeight(_ keyPath: PartialKeyPath<HealthInfo>) -> CGFloat {
        switch keyPath {
            case \.restrictions, \.gestationalWeek: return 0.47
            default: return 0.4
        }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("Edit Health Info") {
            PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) {
                navigationManager.previous()
                userSession.update(healthInfo: healthInfo)
            }
        } trailing: { EmptyView() }

    }
}

