//
//  LoadingView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Lottie
import SwiftUI

struct LoadingView: View {
    @Binding var currentProcedure: Int
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack(spacing: 0) {
                icon
                    .padding(.bottom, 40)
                
                instruction
                    .padding(.bottom, 12)
                
                loadingMessage
                    .padding(.bottom, 56)
                
                procedures
                
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private var backgroundColor: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    private var icon: some View {
        LottieView(animation: .named("loadingBloomPot"))
            .looping()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
    }
    
    private var instruction: some View {
        Text(Localization.Loading.loadingInstruction)
            .textStyle(typographies.paragraph1)
            .foregroundStyle(PLColor.neutral600)
    }
    
    private var loadingMessage: some View {
        Text(Localization.Loading.loadingTitle)
            .textStyle(typographies.heading2)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var procedures: some View {
        VStack(spacing: 12) {
            Text(Localization.Loading.loadingStepImageReview)
                .textStyle(typographies.label)
                .foregroundStyle(currentProcedure == 1 ? PLColor.neutral800 : PLColor.neutral300)
            Text(Localization.Loading.loadingStepCheckIngredient)
                .textStyle(typographies.label)
                .foregroundStyle(currentProcedure == 2 ? PLColor.neutral800 : PLColor.neutral300)
            Text(Localization.Loading.loadingStepCollectDetail)
                .textStyle(typographies.label)
                .foregroundStyle(currentProcedure == 3 ? PLColor.neutral800 : PLColor.neutral300)
            
        }
    }
}

#Preview {
    @Previewable @State var currentProcedure = 1
    LoadingView(currentProcedure: $currentProcedure)
}
