//
//  HealthInfoConfirmationView.swift
//  Junction
//
//  Created by 송지혁 on 12/2/24.
//

import ComposableArchitecture
import SwiftUI

struct HealthInfoConfirmView: View {
    @Environment(\.plTypographySet) var typographies
    
    @Bindable var store: StoreOf<HealthInfoConfirmReducer>
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            headline
                .padding(.top, 100)
        } content: {
            VStack(spacing: 0) {
                HealthInfoListView(healthInfo: store.healthInfo, mode: store.mode)
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
                           shape: .rect) { store.send(.backButtonTapped) }
           
            PLActionButton(label: Localization.Button.confirmButtonTitle,
                           type: .primary,
                           contentType: .text,
                           size: .large,
                           shape: .rect) { store.send(.confirmButtonTapped) }
        }
    }
}
