//
//  PaymentView.swift
//  Junction
//
//  Created by 송지혁 on 9/20/24.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @State private var selectedSeeds: Int = 0
    @EnvironmentObject var store: Store
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    @Environment(\.dismiss) var dismiss
    @Environment(\.plTypographySet) var typographies
    
    var remainingSeeds: UInt {
        guard let userInfo = userSession.userInfo else { return 0 }
        return userInfo.remainingTimes
    }
    
    var totalPrice: String {
        let price = Decimal(selectedSeeds) * 0.1
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(for: price) ?? "0.00"
    }

    var productID: String { String(selectedSeeds / 10) }
    
    
    var body: some View {
        StepTemplate(backgroundColor: background, contentTopPadding: 20) {
            navigationHeader
        } content: {
            purchaseView
        } buttons: {
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
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader(Localization.NavigationHeader.navigationHeaderGetMoreSeedsTitle) { EmptyView() }
        trailing: {
            PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { dismiss() }
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
                    PLSlider(selectedValue: $selectedSeeds)
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
                Text("\(selectedSeeds)")
                    .textStyle(typographies.display)
                    .foregroundStyle(PLColor.neutral800)
                    .alignmentGuide(.bottom) { $0[.bottom] - 4 }
                
                Text(Localization.Label.inAppProductUnitLabel)
                    .textStyle(typographies.heading2)
                    .foregroundStyle(PLColor.neutral800)
            }
            
            Spacer()
            
            Text(Localization.Label.costWithSymbol(totalPrice))
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
            
            Text("\(remainingSeeds) \(Localization.Label.inAppProductUnitLabel)")
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
            PLActionButton(label: Localization.Button.buyNowButtonTitle, type: .primary, contentType: .text, size: .large, shape: .rect, isDisabled: selectedSeeds == 0) {
                Task {
                    guard let product = store.storeProducts.first(where: { $0.id == "com.prelude.seeds.\(productID)usd"  }) else { return }
                    guard let seedCount = Int(productID) else { return }
                    guard let _ = await store.purchase(product) else { return }
                    try? await userSession.incrementSeeds(seedCount * 10)
                    await MainActor.run { dismiss() }
                    EventBus.shared.toastPublisher.send(.paymentCompleted(seedCount * 10))
                }
                
            }
            
            Text(Localization.Label.purchaseDescription)
                .textStyle(typographies.caption)
                .foregroundStyle(PLColor.neutral900)
                .multilineTextAlignment(.center)
        }
    }
}
