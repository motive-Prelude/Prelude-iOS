//
//  OnboardingTabContent.swift
//  Junction
//
//  Created by 송지혁 on 12/27/24.
//

import SwiftUI

struct OnboardingTabContent: View {
    let image: Image
    let title: String
    let description: String
    
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        VStack(spacing: 32) {
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 35)
                
            Group {
                Text(title)
                    .textStyle(typographies.heading1)
                    .foregroundStyle(PLColor.neutral800)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .textStyle(typographies.paragraph1)
                    .foregroundStyle(PLColor.neutral600)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 51)
        }
        
        
    }
}

#Preview {
    OnboardingTabContent(image: Image(.onboarding1Illust),
                         title: "Enjoy meals with\npeace of mind",
                         description: "We’re here with food safety tips so you can enjoy meals without worry during your pregnancy.")
}
