//
//  WelcomeView.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    @Environment(\.plTypographySet) var typographies
    
    @Bindable var store: StoreOf<WelcomeReducer>
    
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
            EmptyView()
        } trailing: { EmptyView() }
    }
    
    private var welcomeGift: some View {
        VStack(spacing: 24) {
            Text(Localization.Label.welcomeGiftTitle)
                .textStyle(typographies.heading1)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.3)
            
            Image(.welcomeGift)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(Localization.Label.welcomeGiftContent)
            .textStyle(typographies.paragraph1)
            .foregroundStyle(PLColor.neutral700)
            .lineLimit(8)
            .minimumScaleFactor(0.3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var startButton: some View {
        PLActionButton(label: Localization.Button.receiveGiftButtonTitle,
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect) { store.send(.receiveGiftButtonTapped) }
    }
}
