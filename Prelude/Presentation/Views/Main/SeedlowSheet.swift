//
//  SeedlowSheet.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import SwiftUI

struct SeedlowSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.plTypographySet) var typographies
    let action: () -> ()
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            
            dragIndicator
                .padding(.top, 12)
            
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Spacer()
                    cancelButton
                }
                .padding(.top, 16)
                .padding(.bottom, 4)
                
                content
                Spacer()
                
                PLActionButton(label: Localization.Button.getMoreButtonTitle, type: .primary, contentType: .text, size: .large, shape: .rect) {
                    dismiss()
                    action()
                }
                    .padding(.bottom, 11)
                
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var dragIndicator: some View {
        VStack {
            Capsule()
                .frame(width: 56, height: 4)
                .foregroundStyle(PLColor.neutral200)
            Spacer()
        }
    }
    
    private var cancelButton: some View {
        PLActionButton(icon: Image(.close), type: .secondary, contentType: .icon, size: .small, shape: .square) { dismiss() }
    }
    
    private var background: some View {
        PLColor.neutral50
            .ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(spacing: 8) {
            icon
            title
            description
        }
    }
    
    private var icon: some View {
        Image(.seedlow)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
        
    }
    
    private var title: some View {
        Text(Localization.Label.seedWarningTitle)
            .textStyle(typographies.heading1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var description: some View {
        Text(Localization.Label.seedWarningSubtitle)
            .textStyle(typographies.paragraph1)
            .foregroundStyle(PLColor.neutral600)
            .multilineTextAlignment(.center)
    }
}
