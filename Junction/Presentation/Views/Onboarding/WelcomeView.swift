//
//  WelcomeView.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 16) {
            navigationHeader
        } content: {
            VStack {
                welcomeGift
                Spacer()
            }
        } buttons: {
            startButton
        }

    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) { navigationManager.previous() }
        } trailing: { EmptyView() }
    }
    
    private var welcomeGift: some View {
        VStack(spacing: 24) {
            Text("A little gift\nfor your peace of mind")
                .textStyle(.heading1)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(.welcomeGift)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("""
                 We know even small worries can feel overwhelming when you’re expecting.
                 
                 With that in mind, we’d like to offer you a small gift: three test seeds you can use any time you need to check if your food is safe.
                 
                 We hope these seeds bring a bit more peace of mind as you prepare to welcome new life.
                 """)
            .textStyle(.paragraph1)
            .foregroundStyle(PLColor.neutral700)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var startButton: some View {
        PLActionButton(label: "Receive seeds & Begin", type: .primary, contentType: .text, size: .large, shape: .rect) {
            Task {
                try? await userSession.incrementSeeds(3)
                navigationManager.navigate(.main)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
