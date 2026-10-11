//
//  MainView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    @EnvironmentObject var keyboardObserver: KeyboardObserver
    @Environment(\.plTypographySet) var typographies
    @State private var isFocused = false
    
    @Bindable var store: StoreOf<MainReducer>
    
    var body: some View {
        ZStack {
            PLColor.neutral50
                .ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                navigationHeader
                
                Spacer()
                
                if !isFocused  { greetingText }
                
                DishPlateView(image: store.foodImage) { store.send(.retakePhoto) }
                onRemove: { store.send(.removeImage) }
                onCapture: { store.send(.showImagePicker) }

                
                if let _ = store.foodImage {
                    foodNameTextField
                        .padding(.bottom, isFocused ? 70 : 0)
                }
                
                Spacer()
                
                testView
                
                if let _ = store.foodImage { button }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
        }
        
        .fullScreenCover(item: $store.scope(state: \.destination?.imagePicker, action: \.destination.imagePicker)) { _ in ImagePicker(sourceType: .camera) { store.send(.imagePicked($0)) } }
        .sheet(item: $store.scope(state: \.destination?.seedlow, action: \.destination.seedlow)) { _ in
            SeedlowSheet { store.send(.showPurchaseView) }
                .presentationDetents([.fraction(0.45)])
                .presentationCornerRadius(24)
        }
        .fullScreenCover(item: $store.scope(state: \.destination?.purchase, action: \.destination.purchase)) { store in
            PurchaseView(store: store)
        }
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(label: "\(store.user?.remainingTimes ?? 0)",
                           icon: Image(.logo),
                           type: .secondary,
                           contentType: store.user?.remainingTimes == 0 ? .seedLow : .seedFull,
                           size: .medium,
                           shape: .pill) { store.send(.showPurchaseView) }
        } trailing: {
            PLActionButton(icon: Image(.setting),
                           type: .secondary,
                           contentType: .icon,
                           size: .medium,
                           shape: .circle) { store.send(.navigateToSetting) }
        }
    }
    
    private var greetingText: some View {
        Text(PromptGenerator.shared.greetingPrompt)
            .textStyle(typographies.heading1)
            .foregroundStyle(PLColor.neutral800)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: true, vertical: true)
    }

    private var foodNameTextField: some View {
        PLTextField<HeightUnit>(placeholder: Localization.Placeholder.textFieldPlaceholder,
                                text: $store.foodName,
                                unit: nil,
                                keyboard: .default) { focus in
            withAnimation { isFocused = focus }
        }
    }
    
    @ViewBuilder
    private var button: some View {
        if !isFocused {
            PLActionButton(label: Localization.Button.checkFoodSafetyButtonTitle,
                           type: .primary,
                           contentType: .text,
                           size: .large,
                           shape: .rect,
                           isDisabled: store.foodImage == nil) {
                store.send(.diagnoseButtonTapped)
//                AnalyticsManager.shared.logEvent("음식 검색", parameters: ["음식 이름": store.foodName])
            }
        }
    }
    
    private var testView: some View {
        VStack {
            ScrollView {
                Text(store.foodName)
                    .foregroundStyle(.black)
                
                ForEach(store.citations, id: \.self) { citation in
                    Text(citation.title)
                        .foregroundStyle(.black)
                    Text(citation.url)
                        .foregroundStyle(.black)
                        .padding(.bottom, 16)
                    
                    
                }
            }
            
            
            Button("SearchFood") {
//                Task {
//                    await SignpostLogger.measure(name: "Search Food") {
                        store.send(.searchFoodInformation)
//                    }
//                }
                
            }
        }
    }
}
