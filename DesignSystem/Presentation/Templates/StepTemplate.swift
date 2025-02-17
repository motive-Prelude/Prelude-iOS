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
    let header: () -> Header
    let content: () -> Content
    let footer: () -> Buttons
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    header()
                        .padding(.bottom, contentTopPadding)
                    content()
                    
                    Spacer()
                }
                    
                Spacer()
                footer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
        
    }
}
