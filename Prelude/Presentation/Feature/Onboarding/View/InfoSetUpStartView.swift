//
//  InfoSetUpStartView.swift
//  Junction
//
//  Created by 송지혁 on 12/28/24.
//

import ComposableArchitecture
import SwiftUI

struct InfoSetUpStartView: View {
    @Bindable var store: StoreOf<InfoSetUpStartReducer>
    @Environment(\.plTypographySet) var typographies
    
    var primaryAlertAction: AlertAction {
        return AlertAction(title: Localization.Button.enterInfoButtonTitle, action: { store.send(.navigateTohealthInfoSetUp) })
    }
    var secondaryAlertAction: AlertAction {
        return AlertAction(title: Localization.Button.skipButtonTitle) {
            store.send(.navigateToDisclaimer)
        }
    }
    
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            navigationHeader
        } content: {
            VStack {
                content
                Spacer()
            }
        } footer: {
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
        
        return VStack(spacing: 24) {
            Text(Localization.Label.setupStartTitle)
                .textStyle(typographies.heading1)
                .foregroundStyle(PLColor.neutral800)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Image(.clipboardIllust)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            Text(Localization.Label.setupStartContent)
                .textStyle(typographies.paragraph1)
                .foregroundStyle(PLColor.neutral700)
        }
    }
    
    private var startButton: some View {
        PLActionButton(label: Localization.Button.beginButtonTitle, type: .primary, contentType: .text, size: .large, shape: .rect) {
            store.send(.navigateTohealthInfoSetUp)
        }
    }
    
    private var skipButton: some View {
        PLActionButton(label: Localization.Button.skipButtonTitle, type: .secondary, contentType: .text, size: .medium, shape: .none) {
            store.send(.skipButtonTapped)
            
            
        }
    }
}
