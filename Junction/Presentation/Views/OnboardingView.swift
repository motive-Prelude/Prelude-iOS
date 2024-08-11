//
//  OnboardingView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let onboardingText = "걱정은 이제 그만!\n지금부터 함께 고민해요"
    
    var body: some View {
        ZStack {
            Color.offwhite
            
            VStack(spacing: 51) {
                
                Spacer()
                
                Image("OnboardingGraphic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 212)
                
                Text(onboardingText)
                    .font(.pretendSemiBold20)
                
                Spacer()
                
                
                Text("시작하기")
                    .font(.pretendBold16)
                    .foregroundStyle(.offwhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray1)
                        
                    }
                    .onTapGesture {
                        navigationManager.screenPath.append(.healthInfoSetup)
                    }
                    .padding(.bottom, 36)
            }
            .padding(.horizontal, 24)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    OnboardingView()
}
