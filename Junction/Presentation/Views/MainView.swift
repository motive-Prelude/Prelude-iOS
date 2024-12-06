//
//  MainView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var mainViewModel = MainViewModel()
    @State private var uiImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var foodName = ""
    @State private var isFocused = false
    
    var userSelectPrompt: String {
        if foodName.isEmpty { return "" }
        return "유저가 알려준 음식의 이름은 \(foodName)이야\n"
    }
    
    var body: some View {
        ZStack {
            PLColor.neutral50
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationHeader
                    .padding(.bottom, 70)
                
                guidePrompt
                
                Spacer()
                
                foodNameTextField
                    .padding(.bottom, isFocused ? 10 : 106)
                    
                button
            }
            .padding(.horizontal, 16)
            
            mainDish
            
        }
        .sheet(isPresented: $isShowingImagePicker) { ImagePicker(image: $uiImage, sourceType: .camera) }
        .ignoresSafeArea(.all, edges: [.top, .horizontal])
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(label: "10",
                           icon: Image(.logo),
                           type: .secondary,
                           contentType: .seedFull,
                           size: .medium,
                           shape: .pill) { }
        } trailing: {
            PLActionButton(icon: Image(.setting),
                           type: .secondary,
                           contentType: .icon,
                           size: .medium,
                           shape: .circle) { }
        }
    }
    
    private var guidePrompt: some View {
        Text("What food are you\nworried about?")
            .textStyle(.heading1)
            .foregroundStyle(PLColor.neutral800)
            .multilineTextAlignment(.center)
    }
    
    private var mainDish: some View {
        Image(.dish)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(dishPlate)
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
            .padding(.horizontal)
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
                           shape: .square) { uiImage = nil }
        }
    }
    
    private var photoTriggerButton: some View {
        VStack(spacing: 4) {
            PLActionButton(icon: Image(.capture), type: .primary, contentType: .icon, size: .medium, shape: .circle) { isShowingImagePicker.toggle() }
            
            Text("Take Photo")
                .textStyle(.title1)
                .foregroundStyle(PLColor.neutral800)
        }
    }
    
    private var foodNameTextField: some View {
        PLTextField<HeightUnit>(placeholder: "Enter food name (Optional)",
                                text: $foodName,
                                unit: nil,
                                keyboard: .default) { focus in
            withAnimation { isFocused = focus }
        }
    }
    
    @ViewBuilder
    private var button: some View {
        if !isFocused {
            PLActionButton(label: "Search food safety", type: .primary, contentType: .text, size: .large, shape: .rect) {
                navigationManager.navigate(.result(userSelectPrompt: mainViewModel.prompt + userSelectPrompt, image: uiImage))
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationManager())
        .modelContainer(SwiftDataManager.shared.container)
}
