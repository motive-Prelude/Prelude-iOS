//
//  LoadingView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Lottie
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.offwhite
            
            VStack(spacing: 12) {
                LottieView(animation: .named("loadingAnimation"))
                    .looping()
                    .padding(.bottom, 12)
                
                Text("잠시만 기다려주세요")
                    .font(.pretendSemiBold18)
                    .foregroundStyle(.offblack)
                
                Text("최대 10초 정도 소요될 수 있어요")
                    .font(.pretendRegular14)
                    .foregroundStyle(.gray3)
                
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoadingView()
}
