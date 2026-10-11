//
//  PLToast.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLToast: View {
    @Environment(\.plTypographySet) var typographies
    
    private(set) var icon: Image?
    let message: String
    
    var body: some View {
        HStack(spacing: 4) {
            iconView
            messageView
        }
        .padding(.vertical, 16)
        .padding(.leading, 12)
        .padding(.trailing, 20)
        .background(backgroundView)
        .shadow(color: PLColor.neutral500.opacity(0.3), radius: 10, x: 0, y: 10)
        
    }
    
    @ViewBuilder
    private var iconView: some View {
        if let icon {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
        }
    }
    private var messageView: some View {
        Text(message)
            .textStyle(typographies.paragraph2)
            .foregroundStyle(PLColor.neutral50)
    }
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 26)
            .fill(PLColor.neutral800)
    }
}

#Preview {
    @Previewable @State var pop = false
    if pop {
        PLToast(icon: Image(.checkSmall), message: "Message")
            .transition(.opacity.combined(with: .move(edge: .top)))
            
    }
    
    Button("gogo") { withAnimation(.bouncy(duration: 0.4, extraBounce: 0.1)) { pop.toggle() } }
}
