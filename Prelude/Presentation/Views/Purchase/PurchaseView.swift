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
    
    var remainingSeeds: UInt {
        guard let userInfo = userSession.userInfo else { return 0 }
        return userInfo.remainingTimes
    }
    
    var totalPrice: String { String(format: "%.2f", Double(selectedSeeds) * 0.1) }
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
        PLNavigationHeader("Get more seeds") { EmptyView() }
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
            makeEfficacyText(content: "Always know what’s safe to eat.")
            makeEfficacyText(content: "Make confident choices for you and your baby.")
            makeEfficacyText(content: "Stay informed with reliable food safety info.")
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
                .textStyle(.paragraph2)
                .foregroundStyle(PLColor.neutral600)
        }
    }
    
    private var bill: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(PLColor.neutral800)
                
            
            VStack(spacing: 0) {
                Text("Select what you need")
                    .textStyle(.label)
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
                    .textStyle(.display)
                    .foregroundStyle(PLColor.neutral800)
                
                Text("seeds")
                    .textStyle(.heading2)
                    .foregroundStyle(PLColor.neutral800)
            }
            
            Spacer()
            
            Text("$\(totalPrice)")
                .textStyle(.title2)
                .foregroundStyle(PLColor.neutral500)
        }
    }
    
    private var remainingSeedsBanner: some View {
        HStack {
            logo
            Text("Remaining")
                .textStyle(.title1)
                .foregroundStyle(PLColor.neutral800)
            
            Spacer()
            
            Text("\(remainingSeeds) seeds")
                .textStyle(.label)
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
            PLActionButton(label: "Buy now", type: .primary, contentType: .text, size: .large, shape: .rect, isDisabled: selectedSeeds == 0) {
                Task {
                    guard let product = store.storeProducts.first(where: { $0.id == "com.prelude.seeds.\(productID)usd"  }) else { return }
                    guard let seedCount = Int(productID) else { return }
                    guard let _ = await store.purchase(product) else { return }
                    try? await userSession.incrementSeeds(seedCount * 10)
                    await MainActor.run { dismiss() }
                    EventBus.shared.toastPublisher.send(.paymentCompleted(seedCount * 10))
                }
                
            }
            
            Text("By clicking ‘Buy now’, your payment will be charged to your App Store account at confirmation of purchase. The selected number of seeds will be added to your account immediately. Please note that all purchases are final and non-refundable. ")
                .textStyle(.caption)
                .foregroundStyle(PLColor.neutral900)
        }
    }
}
