//
//  InfoStepTemplate.swift
//  Junction
//
//  Created by 송지혁 on 12/5/24.
//

import SwiftUI

struct StepTemplate<Background: View, Header: View, Content: View, Buttons: View>: View {
    let backgroundColor: Background
    let contentTopPadding: CGFloat
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content
    let footer: () -> Buttons
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header()
                content()
                    .padding(.top, contentTopPadding)
                Spacer()
                buttons()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(.all, edges: [.top, .horizontal, .bottom])
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
        
    }
}
