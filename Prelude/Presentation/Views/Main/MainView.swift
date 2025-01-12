//
//  MainView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.plTypographySet) var typographies
    
    @StateObject var mainViewModel = MainViewModel()
    @State private var uiImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var foodName = ""
    @State private var isFocused = false
    @State private var showpPurchaseView = false
    @State private var showSeedlowSheet = false
    
    var userSelectPrompt: String {
        if foodName.isEmpty { return "" }
        return "유저가 알려준 음식의 이름은 \(foodName)이야\n"
    }
    
    var remainingTimes: UInt {
        guard let userInfo = userSession.userInfo else { return 0 }
        return userInfo.remainingTimes
    }
    
    var body: some View {
        ZStack {
            PLColor.neutral50
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                    .padding(.bottom, 70)
                
                if !isFocused { greetingText }
                
                Spacer()
                
                if let _ = uiImage {
                    foodNameTextField
                        .padding(.bottom, isFocused ? 10 : 106)
                    
                    button
                }
            }
            .padding(.horizontal, 16)
            
            mainDish
            
        }
        .sheet(isPresented: $isShowingImagePicker) { ImagePicker(image: $uiImage, sourceType: .camera) }
        .sheet(isPresented: $showSeedlowSheet) {
            SeedlowSheet { showpPurchaseView = true }
                .presentationDetents([.fraction(0.45)])
                .presentationCornerRadius(24)
        }
        .fullScreenCover(isPresented: $showpPurchaseView) {
            PurchaseView()
                .trackScreen(screenName: "구매 뷰")
        }
        .ignoresSafeArea(.all, edges: [.top, .horizontal])
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
        .onAppear {
            mainViewModel.bind(userSession: userSession)
            mainViewModel.requestTrackingAuthorizationIfNeeded()
        }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(label: "\(remainingTimes)",
                           icon: Image(.logo),
                           type: .secondary,
                           contentType: remainingTimes == 0 ? .seedLow : .seedFull,
                           size: .medium,
                           shape: .pill) { showpPurchaseView = true }
        } trailing: {
            PLActionButton(icon: Image(.setting),
                           type: .secondary,
                           contentType: .icon,
                           size: .medium,
                           shape: .circle) { navigationManager.navigate(.setting) }
        }
    }
    
    private var greetingText: some View {
        Text(PromptGenerator.shared.greetingPrompt)
            .textStyle(typographies.heading1)
            .foregroundStyle(PLColor.neutral800)
            .multilineTextAlignment(.center)
    }
    
    private var mainDish: some View {
        Image(.dish)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 360, height: 360)
            .overlay(dishPlate)
            .padding(.top, 4)
    }
    
    @ViewBuilder
    private var dishPlate: some View {
        if let uiImage { imageView(uiImage) }
        else { photoTriggerButton }
    }
    
    private func imageView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 136)
            .clipShape(Circle())
            .padding(.top, -6)
            .overlay(alignment: .top) { garnishButtons }
    }
    
    private var garnishButtons: some View {
        HStack {
            PLActionButton(icon: Image(.redo),
                           type: .secondary,
                           contentType: .icon,
                           size: .xsmall,
                           shape: .square) { isShowingImagePicker = true }
            Spacer()
            
            PLActionButton(icon: Image(.closeSmall),
                           type: .secondary,
                           contentType: .icon,
                           size: .xsmall,
                           shape: .square) { withAnimation(.linear(duration: 0.2)) { uiImage = nil } }
        }
    }
    
    private var photoTriggerButton: some View {
        VStack(spacing: 4) {
            PLActionButton(icon: Image(.capture), type: .primary, contentType: .icon, size: .medium, shape: .circle) { isShowingImagePicker.toggle() }
            
            Text(Localization.Label.takePhotoLabel)
                .textStyle(typographies.title1)
                .foregroundStyle(PLColor.neutral800)
        }
    }
    
    private var foodNameTextField: some View {
        PLTextField<HeightUnit>(placeholder: Localization.Placeholder.textFieldPlaceholder,
                                text: $foodName,
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
                           isDisabled: uiImage == nil) {
                
                guard NetworkMonitor.shared.isConnected else {
                    EventBus.shared.errorPublisher.send(.networkUnavailable)
                    return
                }
                
                if remainingTimes <= 0 {
                    showSeedlowSheet = true
                    return
                }
                
                navigationManager.navigate(.result(userSelectPrompt: mainViewModel.prompt + userSelectPrompt, image: uiImage))
                self.uiImage = nil
                AnalyticsManager.shared.logEvent("음식 검색", parameters: ["음식 이름": foodName])
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject( UserSession(userRepository: DIContainer.shared.resolve(UserRepository.self)!,
                                        loginUseCase: DIContainer.shared.resolve(LoginUseCase.self)!,
                                        logOutUseCase: DIContainer.shared.resolve(LogOutUseCase.self)!, reauthenticateUseCase: DIContainer.shared.resolve(ReauthenticateUseCase.self)!,
                                        deleteAccountUseCase: DIContainer.shared.resolve(DeleteAccountUseCase.self)!,
                                        observeAuthStateUseCase: DIContainer.shared.resolve(ObserveAuthStateUseCase.self)!))
        .environmentObject(NavigationManager())
}
