//
//  MainView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var mainViewModel = MainViewModel()
    @State private var uiImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var foodName = ""
    
    
    let headerText = """
    Tell us about the food
    you’re worried about
    """
    
    var userSelectPrompt: String {
        if foodName.isEmpty { return "" }
        return "유저가 알려준 음식의 이름은 \(foodName)이야\n"
    }
    
    var body: some View {
        ZStack {
            Color.offwhite
                .contentShape(Rectangle())
                .onTapGesture { UIApplication.shared.endEditing(true) }
            
            VStack(spacing: 0) {
                header
                    .onTapGesture { UIApplication.shared.endEditing(true) }
                
                form
                    .padding(.horizontal, 24)
                
                Spacer()
                
                
                Text("Done")
                    .font(.pretendBold16)
                    .foregroundStyle(.offwhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray1)
                        
                    }
                    .onTapGesture {
                        navigationManager.screenPath.append(.result(userSelectPrompt: userSelectPrompt + mainViewModel.prompt, image: uiImage))
                        uiImage = nil
                        foodName = ""
                    }
                    .padding(.bottom, 36)
                    .padding(.horizontal, 24)
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $uiImage, sourceType: .camera)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .task {
            guard mainViewModel.userStore.userInfo == nil else { return }
            await mainViewModel.userStore.fetchUserInfo()
        }
    }
    
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(headerText)
                    .font(.pretendBold24)
                    .padding(.top, 82)
                    .foregroundStyle(.offblack)
                Text("Take a photo or type in!")
                    .font(.pretendRegular14)
            }
            .padding(.leading, 24)
            
            Spacer()
        }
        .padding(.bottom, 56)
        .frame(maxWidth: .infinity)
        .background {
            Color.gray10
                .overlay(alignment: .bottomTrailing) {
                    Image("tree")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 78)
                }
        }
    }
    
    private var form: some View {
        VStack(spacing: 36) {
            pictureSection
            foodNameSection
        }
        .padding(.top, 24)
    }
    
    private var pictureSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Photo of the food or its name")
                .font(.pretendSemiBold18)
                .foregroundStyle(.offblack)
            
            Image("stitchBox")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .overlay {
                    if let uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 123, height: 123)
                            .clipped()
                            .clipShape(Rectangle())
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "xmark.app.fill")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.offwhite)
                                    .onTapGesture { self.uiImage = nil }
                                    .shadow(radius: 3, y: 3)
                            }
                        
                    } else {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.gray3)
                    }
                }
                .onTapGesture {
                    if let _ = uiImage {
                        UIApplication.shared.endEditing(true)
                        return
                    }
                    isShowingImagePicker = true
                }
        }
    }
    
    private var foodNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Food name")
                .font(.pretendSemiBold18)
                .foregroundStyle(.offblack)
            
            TextField("Type here", text: $foodName)
                .font(.pretendRegular16)
                .foregroundStyle(.offblack)
                .padding(.vertical, 13)
                .padding(.leading, 14)
                .background { RoundedRectangle(cornerRadius: 16).stroke(.gray8, lineWidth: 1) }
        }
    }
}

#Preview {
    MainView()
}
