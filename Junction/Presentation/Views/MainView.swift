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
    @State private var healthInfo: HealthInfo?
    @State private var foodName = ""
    
    var userSelectPrompt: String {
        if foodName.isEmpty { return "" }
        return "유저가 알려준 음식의 이름은 \(foodName)이야"
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
                
                Text("안전한지 확인하기")
                    .font(.pretendBold16)
                    .foregroundStyle(.offwhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray1)
                        
                    }
                    .onTapGesture {
                        navigationManager.screenPath.append(.result(userSelectPrompt: userSelectPrompt, image: uiImage))
                        uiImage = nil
                        foodName = ""
                    }
                    .padding(.bottom, 36)
                    .padding(.horizontal, 24)
            }
            
            
            
            //            Button("테스트") {
            //                mainViewModel.sendMessageForQuiz("이 임산부의 건강 상태는 혈압 낮음, 당뇨 없음, 임신 초기야.", image: uiImage)
            //            }
            //
            //            Button("health") {
            //                healthInfo = mainViewModel.loadHealthInfo()
            //            }
            //
            //            Text(healthInfo?.bloodPressure.rawValue ?? "안됨 저장")
            //
            //
            //            Button(action: {
            //                isShowingImagePicker = true
            //            }) {
            //                Text("Open Camera")
            //                    .padding()
            //                    .background(Color.blue)
            //                    .foregroundColor(.white)
            //                    .cornerRadius(10)
            //            }
            //
            //            ScrollView {
            //                Text(mainViewModel.judgement?.recognition.description ?? "")
            //                Text(mainViewModel.judgement?.productName ?? "")
            //                Text(mainViewModel.judgement?.conclusion ?? "")
            //                ForEach(mainViewModel.judgement?.details ?? [JudgementDetail(title: "", content: "")], id: \.self) { detail in
            //                    VStack {
            //                        Text(detail.title)
            //                            .bold()
            //
            //                        Text(detail.content)
            //                    }
            //                }
            //            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $uiImage, sourceType: .camera)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("걱정되는 음식을 알려주세요")
                    .font(.pretendBold24)
                    .padding(.top, 82)
                    .foregroundStyle(.offblack)
                Text("음식의 사진 또는 이름으로 검색할 수 있어요")
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
            Text("텍스트 또는 음식 사진으로 확인")
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
            Text("음식 이름으로 확인")
                .font(.pretendSemiBold18)
                .foregroundStyle(.offblack)
            
            TextField("음식 이름", text: $foodName)
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
