//
//  InfoStepTemplate.swift
//  Junction
//
//  Created by 송지혁 on 12/5/24.
//

import SwiftUI

struct InfoStepTemplate<Header: View, Content: View, Buttons: View>: View {
    let backgroundColor: Color
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content
    @ViewBuilder let buttons: () -> Buttons
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header()
                content()
                    .padding(.top, 44)
                buttons()
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea(.all, edges: [.top, .horizontal])
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
        
    }
}
