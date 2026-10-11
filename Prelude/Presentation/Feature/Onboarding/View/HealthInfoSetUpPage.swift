//
//  HealthInfoSetUpPage.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import ComposableArchitecture
import SwiftUI

enum TabSelection: Int, CaseIterable, Hashable {
    case basic = 1
    case medicalHistory
    case allergies
    
    static var totalCount: Int { allCases.count }
}

struct HealthInfoSetUpPage: View {
    @Bindable var store: StoreOf<HealthInfoSetupReducer>
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            VStack(spacing: 0) {
                navigationHeader
                headline
                    .layoutPriority(1)
            }
        } content: {
            VStack(spacing: 0) {
                tabs
                Spacer()

            }
        } footer: {
            VStack(spacing: 16) {
                pageIndicator
                button
            }
            .layoutPriority(1)
        }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(icon: Image(.back),
                           type: .secondary,
                           contentType: .icon,
                           size: .small,
                           shape: .square) { store.send(.backButtonTapped) }
        } trailing: {
            PLActionButton(label: Localization.Button.skipButtonTitle,
                           type: .secondary,
                           contentType: .text,
                           size: .medium,
                           shape: .none) {
                store.send(.nextButtonTapped)
            }
        }
    }
    
    private var headline: some View {
        VStack(spacing: 8) {
            Image("Page\(store.currentPage+1)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
            
            Text(headLineTitle(store.currentPage+1))
                .textStyle(typographies.heading2)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.center)
        }
    }
    
    private func headLineTitle(_ currentPage: Int) -> String {
        switch currentPage {
            case 1: return Localization.Label.basicInfoTitle
            case 2: return Localization.Label.medicalHistoryTitle
            case 3: return Localization.Label.allergyTitle
            case 4: return Localization.Label.confirmTitle
            default: return ""
        }
    }
    
    private var tabs: some View {
        VStack(spacing: 0) {
            switch TabSelection(rawValue: store.currentPage+1) {
                case .basic:
                    BasicInfoSetUpView(gestationalWeek: $store.gestationalWeek, height: $store.height, weight: $store.weight)
                    
                case .medicalHistory:
                    MedicalInfoSetUpView(bloodPressure: $store.bloodPressure,
                                         diabetes: $store.diabetes)
                    
                case .allergies:
                    AllergiesInfoSetUpView(allergies: $store.allergies)
                    
                default: EmptyView()
            }
            
            Spacer()
        }
    }
    
    private var pageIndicator: some View {
        PLPageIndicator(currentPage: $store.currentPage, totalCount: TabSelection.totalCount)
    }
    
    private var button: some View {
        PLActionButton(label: Localization.Button.nextButtonTitle,
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect) {
            if store.currentPage == TabSelection.totalCount - 1 {
                store.send(.saveButtonTapped)
            } else {
                store.send(.nextButtonTapped)
            }
        }
    }
}
