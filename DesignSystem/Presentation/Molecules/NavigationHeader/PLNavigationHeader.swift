//
//  PLNavigationHeader.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct PLNavigationHeader<Leading: View, Trailing: View>: View {
    let title: String
    let leadingItem: () -> Leading
    let trailingItem: () -> Trailing
    
    
    var body: some View {
        HStack(spacing: 0) {
            leadingItem()
            Spacer()
            Text(title)
                .textStyle(.label)
                .foregroundStyle(PLColor.neutral800)
            Spacer()
            trailingItem()
        }
        .padding(.bottom, 12)
        .padding(.top, 60)
    }

}

extension PLNavigationHeader {
    init(_ title: String, leading: @escaping () -> Leading, trailing: @escaping () -> Trailing) {
        self.title = title
        self.leadingItem = leading
        self.trailingItem = trailing
    }
}

#Preview {
    PLNavigationHeader("Title") {
        PLActionButton(icon: Image(.back), type: .secondary, contentType: .icon, size: .small, shape: .square) {
            
        }
    } trailing: {
        PLActionButton(label: "Skip", type: .secondary, contentType: .text, size: .medium, shape: .none) {
            
        }
    }
}
