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
        AlertAction(title: Localization.Button.retryButtonTitle) {
            Task { await checkValidation() }
        }
    }
    
    var cancelAlertAction: AlertAction {
        AlertAction(title: Localization.Button.cancelButtonTitle) { dismiss() }
    }
    
    var getMoreAlertAction: AlertAction {
        AlertAction(title: Localization.Button.getMoreButtonTitle) { dismiss() }
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
            alertManager.showAlert(title: Localization.Dialog.dialogNoSeedTitle,
                                   message: Localization.Dialog.dialogNoSeedDescription,
                                   actions: [cancelAlertAction, getMoreAlertAction])
        }
    }
    
    private func checkFoodOrNotOnLocal(image: UIImage) {
        resultViewModel.detectFoodOrNot(image: image) { result in
            if result {
                processNextProcedure()
                Task { await sendMessage(image: image) }
            } else {
                alertManager.showAlert(title: Localization.Dialog.dialogNotFoodTitle,
                                       message: Localization.Dialog.dialogNotFoodDescription,
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
            case .networkUnavailable: alertManager.showAlert(title: Localization.Dialog.dialogNetworkErrorTitle,
                                                             message: Localization.Dialog.dialogNetworkErrorDescription,
                                                             actions: [cancelAlertAction, retryAlertAction])
            case .serverError: alertManager.showAlert(title: Localization.Dialog.dialogServerErrorTitle,
                                                      message: Localization.Dialog.dialogServerErrorDescription,
                                                      actions: [cancelAlertAction, retryAlertAction])
                
            case .timeout: alertManager.showAlert(title: Localization.Dialog.dialogTimeOutTitle,
                                                  message: Localization.Dialog.dialogTimeOutDescription,
                                                  actions: [cancelAlertAction, retryAlertAction])
                
            default: alertManager.showAlert(title: Localization.Dialog.dialogUnknownErrorTitle,
                                            message: Localization.Dialog.dialogUnknownErrorDescription,
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
                PLNavigationHeader(Localization.NavigationHeader.navigationHeaderReportTitle) {
                    EmptyView()
                } trailing: {
                    PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { dismiss() }
                }
                ScrollView(showsIndicators: false) {
                    headline(result: result)
                    resultContent
                    
                    Spacer()
                }
                .padding(.bottom, 8)
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
                        Text(Localization.Result.resultTitleFoodName(judgement.productName))
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
                return Localization.Result.positiveResultTitle
            case .caution:
                return Localization.Result.cautionResultTitle
            case .negative:
                return Localization.Result.negativeResultTitle
        }
    }
    
    @ViewBuilder
    private var resultContent: some View {
        if let judgement = resultViewModel.judgement {
                Text(judgement.conclusion)
                .textStyle(typographies.paragraph1)
                .foregroundStyle(PLColor.neutral800)
                    .padding(.bottom, 10)
                    .padding(.top, 44)
                
                ForEach(judgement.details, id: \.self) { detail in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(detail.title)
                            .textStyle(typographies.label)
                            .foregroundStyle(PLColor.neutral800)
                        
                        Text(detail.content)
                            .textStyle(typographies.paragraph1)
                            .foregroundStyle(PLColor.neutral800)
                    }
                    .padding(.bottom, 10)
                }
                
                chatGPTWarning
        }
    }
    
    private var chatGPTWarning: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 16))
                .foregroundStyle(PLColor.negative)
            
            Text(Localization.Label.aiWarningLabel)
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

