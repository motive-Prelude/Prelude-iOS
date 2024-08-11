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
                
                Text("We’re checking if it’s safe!")
                    .font(.pretendSemiBold18)
                    .foregroundStyle(.offblack)
                
                Text("This process can take up to 10 seconds")
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
