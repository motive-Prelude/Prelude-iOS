//
//  ResultView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import SwiftUI

enum JudgeResult {
    case positive
    case negative
}

struct ResultView: View {
    let userSelectedPrompt: String
    let image: UIImage?
    @StateObject var resultViewModel = ResultViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.offwhite
            
            if resultViewModel.isLoading == nil || resultViewModel.isLoading == true {
                LoadingView()
                    .onAppear {
                        resultViewModel.sendMessage(userSelectedPrompt, image: image)
                    }
            } else {
                resultView
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        
    }
    
    private var resultView: some View {
        if let judgement = resultViewModel.judgement, judgement.safetyAssessment {
            resultLayout(result: .positive)
        } else {
            resultLayout(result: .negative)
        }
    }
    
    @ViewBuilder
    private func resultLayout(result: JudgeResult) -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header(result: result)
                resultContent
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            
            
            ZStack {
                Rectangle()
                    .fill(.offwhite)
                    .frame(height: 80)
                    .overlay(alignment: .bottom) {
                        Text("Return")
                            .font(.pretendBold16)
                            .foregroundStyle(.offwhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.gray1)
                            }
                            .onTapGesture { dismiss() }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 36)
                    }
                
            }
        }
    }
    
    @ViewBuilder
    private func header(result: JudgeResult) -> some View {
        if let judgement = resultViewModel.judgement {
            VStack(spacing: 14) {
                Image(result == .positive ? "circleBubble" : "xBubble")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72)
                    .padding(.top, 97)
                
                VStack(spacing: 4) {
                    Text(result == .positive ? "No need to worry!" : "Be a little cautious!")
                        .font(.pretendSemiBold28)
                        .foregroundStyle(.offblack)
                    
                    HStack(spacing: 0) {
                        
                        
                        Text("Results on ")
                            .font(.pretendMedium18)
                            .foregroundStyle(.offblack)
                        
                        Text(judgement.productName)
                            .font(.pretendMedium18)
                            .foregroundStyle(result == .positive ? .green1 : .pink1)
                    }
                    .padding(.bottom, 59)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.gray10)
        } else {
            EmptyView()
        }
    }
    
    private var resultContent: some View {
        Group {
            if let judgement = resultViewModel.judgement {
                ScrollView(showsIndicators: false) {
                    chatGPTWarning
                    
                    Text(judgement.conclusion)
                        .font(.pretendRegular16)
                        .foregroundStyle(.offblack)
                        .padding(.bottom, 10)
                    
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
                }
                .padding(.vertical, 24)
                .padding(.bottom, 100)
            } else {
                EmptyView()
            }
        }
    }
    
    private var chatGPTWarning: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 16))
                .foregroundStyle(.pink1)
            
            Text("ChatGPT can make mistakes. Check important info.")
                .font(.pretendRegular12)
                .foregroundStyle(.gray3)
            
            Spacer()
        }
        .padding(.bottom, 24)
    }
}
