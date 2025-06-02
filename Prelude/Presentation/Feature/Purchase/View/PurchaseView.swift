//
//  PaymentView.swift
//  Junction
//
//  Created by 송지혁 on 9/20/24.
//

import ComposableArchitecture
import SwiftUI
import StoreKit

struct PurchaseView: View {
    @Environment(\.plTypographySet) var typographies
    @Bindable var store: StoreOf<StoreReducer>
    
    var body: some View {
        StepTemplate(backgroundColor: background, contentTopPadding: 20) {
            navigationHeader
        } content: {
            purchaseView
        } footer: {
            footer
        }
    }
    
    private var background: some View {
        ZStack {
            PLColor.neutral50
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(.hill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear { store.send(.onAppear) }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderGetMoreSeedsTitle) { EmptyView() }
        trailing: {
            PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { store.send(.backButtonTapped) }
        }

    }
    
    private var purchaseView: some View {
        VStack(spacing: 20) {
            remainingSeedsBanner
            bill
            efficacyText
            Spacer()
        }
    }
    
    private var efficacyText: some View {
        VStack(alignment: .leading, spacing: 8) {
            makeEfficacyText(content: Localization.Label.firstPurchaseBenefit)
            makeEfficacyText(content: Localization.Label.secondPurchaseBenefit)
            makeEfficacyText(content: Localization.Label.thirdPurchaseBenefit)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder func makeEfficacyText(content: String) -> some View {
        HStack(spacing: 4) {
            Image(.check)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
            
            Text(content)
                .textStyle(typographies.paragraph2)
                .foregroundStyle(PLColor.neutral600)
        }
    }
    
    private var bill: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(PLColor.neutral800)
                
            
            VStack(spacing: 0) {
                Text(Localization.Label.purchaseInstruction)
                    .textStyle(typographies.label)
                    .foregroundStyle(PLColor.neutral50)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                VStack(spacing: 0) {
                    reciptContent
                    Spacer()
                    PLSlider(selectedValue: $store.selectedSeeds)
                        .padding(.bottom, 28)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .frame(maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(PLColor.neutral50)
                        .strokeBorder(PLColor.neutral800, lineWidth: 4)
                }
            }
        }
        .frame(height: 228)
    }
    
    private var reciptContent: some View {
        HStack(alignment: .bottom) {
            HStack(alignment: .bottom, spacing: 4) {
                Text("\(store.selectedSeeds)")
                    .textStyle(typographies.display)
                    .foregroundStyle(PLColor.neutral800)
                    .alignmentGuide(.bottom) { $0[.bottom] - 4 }
                
                Text(Localization.Label.inAppProductUnitLabel)
                    .textStyle(typographies.heading2)
                    .foregroundStyle(PLColor.neutral800)
            }
            
            Spacer()
            
            Text(Localization.Label.costWithSymbol(store.totalPrice))
                .textStyle(typographies.title2)
                .foregroundStyle(PLColor.neutral500)
        }
    }
    
    private var remainingSeedsBanner: some View {
        HStack {
            logo
            Text(Localization.Label.remainingLabel)
                .textStyle(typographies.title1)
                .foregroundStyle(PLColor.neutral800)
            
            Spacer()
            
            Text("\(store.remainingSeeds) \(Localization.Label.inAppProductUnitLabel)")
                .textStyle(typographies.label)
                .foregroundStyle(PLColor.neutral800)
            
        }
        .padding(.vertical, 12)
        .padding(.leading, 12)
        .padding(.trailing, 28)
        .background { RoundedRectangle(cornerRadius: 24).fill(PLColor.neutral100) }
    }
    
    private var logo: some View {
        Image(.logo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44)
    }
    
    private var footer: some View {
        VStack(spacing: 14) {
            PLActionButton(label: Localization.Button.buyNowButtonTitle, type: .primary, contentType: .text, size: .large, shape: .rect, isDisabled: store.selectedSeeds == 0) {
                store.send(.purchaseButtonTapped)
            }
            
            Text(Localization.Label.purchaseDescription)
                .textStyle(typographies.caption)
                .foregroundStyle(PLColor.neutral900)
                .multilineTextAlignment(.center)
        }
    }
}
