//
//  ResultView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

enum JudgeResult {
    case positive
    case caution
    case negative
}

struct ResultView: View {
    let userSelectedPrompt: String
    let image: UIImage?
    @StateObject var resultViewModel = ResultViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var alertManager: AlertManager
    @State private var currentProcedure = 1
    @State private var retryCount = -1
    
    var body: some View {
        ZStack {
            backgroundColor
            
            if resultViewModel.isLoading == nil || resultViewModel.isLoading == true {
                LoadingView(currentProcedure: $currentProcedure)
                    .task { await checkValidation() }
            } else {
                resultView
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        
    }
    
    private func checkValidation() async {
        if retryCount > 2 {
            dismiss()
            return
        }
        
        initiateProcedure()
        guard let image = image else { return }
        guard let recentUserInfo = try? await userSession.syncCurrentUserFromServer() else { return }
        
        incrementRetryCount()
        checkNotEnoughSeeds(userInfo: recentUserInfo)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { processNextProcedure() }
        checkFoodOrNotOnLocal(image: image)
        
    }
    
    private func checkNotEnoughSeeds(userInfo: UserInfo) {
        if userInfo.remainingTimes < 1 {
            alertManager.showAlert(title: "No seeds left",
                                   message: "You’ve used up all your seeds. Purchase more to continue checking food safety.",
                                   actions: [AlertAction(title: "Cancel", action: { dismiss() }),
                                             AlertAction(title: "Get more") { dismiss() }
                                            ])
        }
    }
    
    private func checkFoodOrNotOnLocal(image: UIImage) {
        resultViewModel.detectFoodOrNot(image: image) { result in
            if result {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { processNextProcedure() }
                Task { await sendMessage(image: image) }
            } else {
                alertManager.showAlert(title: "Not a food item",
                                       message: "The picture doesn’t seem to contain food. Please upload a clear food image.",
                                       actions: [AlertAction(title: "Cancel", action: { dismiss() }),
                                                 AlertAction(title: "Retry") { Task { await checkValidation() } }
                                                ])
            }
        }
    }
    
    private func sendMessage(image: UIImage) async {
        if await resultViewModel.sendMessage(userSelectedPrompt, image: image) {
            try? await userSession.decrementSeeds(1)
            
        } else { alertManager.showAlert(title: "Unexpected error",
                                        message: "An error occurred while processing your request. Please try again shortly.",
                                        actions: [AlertAction(title: "Cancel", action: { dismiss() }),
                                                  AlertAction(title: "Retry") { Task { await checkValidation() } }
                                                 ]) }
    }
    
    private func initiateProcedure() {
        withAnimation { currentProcedure = 1 }
    }
    
    private func processNextProcedure() {
        withAnimation { currentProcedure += 1 }
    }
    
    private func incrementRetryCount() { retryCount += 1 }
    
    private var backgroundColor: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var resultView: some View {
        if let judgement = resultViewModel.judgement {
            switch judgement.safetyAssessment {
                case "positive":
                    resultLayout(result: .positive)
                case "caution":
                    resultLayout(result: .caution)
                case "negative":
                    resultLayout(result: .negative)
                default: EmptyView()
                    
            }
        }
    }
    
    @ViewBuilder
    private func resultLayout(result: JudgeResult) -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 8) {
                PLNavigationHeader("Safety Report") {
                    EmptyView()
                } trailing: {
                    PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { dismiss() }
                }
                
                headline(result: result)
                resultContent
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func headline(result: JudgeResult) -> some View {
        if let judgement = resultViewModel.judgement {
            VStack(spacing: 8) {
                resultImage(result)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 16) {
                    Text(resultInstruction(result))
                        .textStyle(.heading1)
                        .foregroundStyle(PLColor.neutral800)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 0) {
                        Text("Results on ")
                            .textStyle(.title1)
                            .foregroundStyle(PLColor.neutral800)
                        
                        Text("'\(judgement.productName)'")
                            .textStyle(.title1)
                            .foregroundStyle(PLColor.neutral800)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            EmptyView()
        }
    }
    
    private func resultImage(_ result: JudgeResult) -> Image {
        switch result {
            case .positive:
                return Image(.positiveCircle)
            case .caution:
                return Image(.cautionTriangle)
            case .negative:
                return Image(.negativeX)
        }
    }
    
    private func resultInstruction(_ result: JudgeResult) -> String {
        switch result {
            case .positive:
                return "All good!\nEnjoy"
            case .caution:
                return "Caution advised.\nStay alert!"
            case .negative:
                return "Not safe!\nAvoid this one."
        }
    }
    
    @ViewBuilder
    private var resultContent: some View {
        if let judgement = resultViewModel.judgement {
            ScrollView(showsIndicators: false) {
                Text(judgement.conclusion)
                    .font(.pretendRegular16)
                    .foregroundStyle(.offblack)
                    .padding(.bottom, 10)
                    .padding(.top, 44)
                
                ForEach(judgement.details, id: \.self) { detail in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detail.title)
                            .font(.pretendSemiBold16)
                            .foregroundStyle(.offblack)
                        
                        Text(detail.content)
                            .font(.pretendRegular16)
                            .foregroundStyle(.offblack)
                    }
                    .padding(.bottom, 10)
                }
                
                chatGPTWarning
            }
            .padding(.bottom, 8)
        }
    }
    
    private var chatGPTWarning: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 16))
                .foregroundStyle(PLColor.negative)
            
            Text("This is guidance only. Confirm for safety.")
                .textStyle(.caption)
                .foregroundStyle(PLColor.neutral800)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(PLColor.neutral100))
        .padding(.bottom, 24)
    }
}

