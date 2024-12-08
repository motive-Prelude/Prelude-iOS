//
//  PLListItem.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLListItem: View {
    let title: String
    let supportingText: String
    let type: ListItemType
    private(set) var action: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 4) {
            titleView
                .frame(width: 140, alignment: .leading)
            
            Spacer()
            
            supportingTextView
                .frame(width: 140, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)

            chevron
                .frame(width: 16, height: 16)
        }
        .multilineTextAlignment(.leading)
        .padding(.vertical, 22)
        .padding(.leading, 24)
        .padding(.trailing, trailingPadding)
        .background(backgroundView)
        .onTapGesture {
            if case .active = type, let action { action() }
        }
        
    }
    
    private var trailingPadding: CGFloat {
        if case .active = type { return 12 }
        return 24
    }
    
    private var titleView: some View {
        Text(title)
            .textStyle(.label)
            .foregroundStyle(PLColor.neutral600)
            
    }
    private var supportingTextView: some View {
        Text(supportingText)
            .textStyle(.paragraph1)
            .foregroundStyle(PLColor.neutral800)
            .multilineTextAlignment(.trailing)
    }
    
    @ViewBuilder
    private var chevron: some View {
        if case .active = type {
            Image(.chevronRight)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(PLColor.neutral100)
    }
}

#Preview {
    PLListItem(title: "Title",
               supportingText: "Supporting Text",
               type: .active) { print("Hello!") }
    
    PLListItem(title: "Title",
               supportingText: "Supporting Text",
               type: .passive)
}


extension PLListItem {
    init(title: String, supportingText: String, _ type: ListItemType, action: (() -> Void)? = nil) {
        self.title = title
        self.supportingText = supportingText
        self.type = type
        self.action = action
    }
}
