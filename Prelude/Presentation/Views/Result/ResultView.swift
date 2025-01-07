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
    @Environment(\.plTypographySet) var typographies
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var alertManager: AlertManager
    @State private var currentProcedure = 1
    @State private var retryCount = -1
    
    var retryAlertAction: AlertAction {
        AlertAction(title: "Retry") {
            Task { await checkValidation() }
        }
    }
    
    var cancelAlertAction: AlertAction {
        AlertAction(title: "Cancel") { dismiss() }
    }
    
    var getMoreAlertAction: AlertAction {
        AlertAction(title: "Get more") { dismiss() }
    }
    
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
        guard let image else { return }
        guard let recentUserInfo = try? await userSession.syncCurrentUserFromServer() else { return }
        processNextProcedure()
        incrementRetryCount()
        
        checkNotEnoughSeeds(userInfo: recentUserInfo)
        
        checkFoodOrNotOnLocal(image: image)
    }
    
    private func checkNotEnoughSeeds(userInfo: UserInfo) {
        if userInfo.remainingTimes < 1 {
            alertManager.showAlert(title: "No seeds left",
                                   message: "You’ve used up all your seeds. Purchase more to continue checking food safety.",
                                   actions: [cancelAlertAction, getMoreAlertAction])
        }
    }
    
    private func checkFoodOrNotOnLocal(image: UIImage) {
        resultViewModel.detectFoodOrNot(image: image) { result in
            if result {
                processNextProcedure()
                Task { await sendMessage(image: image) }
            } else {
                alertManager.showAlert(title: "Not a food item",
                                       message: "The picture doesn’t seem to contain food. Please upload a clear food image.",
                                       actions: [cancelAlertAction, retryAlertAction])
            }
        }
    }
    
    private func sendMessage(image: UIImage) async {
        do {
            try await resultViewModel.sendMessage(userSelectedPrompt, image: image)
            try await userSession.decrementSeeds(1)
        } catch { showAlert(error) }
    }
    
    private func initiateProcedure() {
        withAnimation { currentProcedure = 1 }
    }
    
    private func processNextProcedure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { currentProcedure += 1 }
        }
    }
    
    private func incrementRetryCount() { retryCount += 1 }
    
    private func showAlert(_ error: DomainError) {
        switch error {
            case .networkUnavailable: alertManager.showAlert(title: "Network unavailable",
                                                             message: "It seems you’re not connected to the internet. Please check your connection and try again.",
                                                             actions: [cancelAlertAction, retryAlertAction])
            case .serverError: alertManager.showAlert(title: "Server issue",
                                                      message: "We’re having trouble connecting to the server. Please try again later.",
                                                      actions: [cancelAlertAction, retryAlertAction])
                
            case .timeout: alertManager.showAlert(title: "Request timed out",
                                                  message: "The request took too long to process. Please check your connection and try again.",
                                                  actions: [cancelAlertAction, retryAlertAction])
                
            default: alertManager.showAlert(title: "Unexpected error",
                                                  message: "An error occurred while processing your request. Please try again shortly.",
                                                  actions: [cancelAlertAction, retryAlertAction])
        }
    }
    
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
                        .textStyle(typographies.heading1)
                        .foregroundStyle(PLColor.neutral800)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 0) {
                        Text("Results on ")
                            .textStyle(typographies.title1)
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
                .textStyle(typographies.paragraph1)
                    .foregroundStyle(.offblack)
                    .padding(.bottom, 10)
                    .padding(.top, 44)
                
                ForEach(judgement.details, id: \.self) { detail in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detail.title)
                            .textStyle(typographies.label)
                            .foregroundStyle(.offblack)
                        
                        Text(detail.content)
                            .textStyle(typographies.paragraph1)
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
                .textStyle(typographies.caption)
                .foregroundStyle(PLColor.neutral800)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 12).fill(PLColor.neutral100))
        .padding(.bottom, 24)
    }
}

