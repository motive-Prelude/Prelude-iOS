//
//  PLDialog.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLDialog: View {
    let title: String
    let description: String
    
    let cancelButtonLabel: String
    let confirmButtonLabel: String
    
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            contentView
                .padding(.bottom, 28)
            actionButtons
        }
        .padding(20)
        .frame(width: 280)
        .background(backgroundView)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .textStyle(.title1)
            
            Text(description)
                .textStyle(.paragraph1)
        }
    }
    private var actionButtons: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Spacer()
            PLActionButton(label: cancelButtonLabel,
                           type: .secondary,
                           contentType: .text,
                           size: .medium,
                           shape: .none,
                           isDisabled: false) {
                cancelAction()
            }
            
            PLActionButton(label: confirmButtonLabel,
                           type: .primary,
                           contentType: .text,
                           size: .small,
                           shape: .rect,
                           isDisabled: false) {
                confirmAction()
            }
        }
    }
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(PLColor.neutral50)
    }
}

#Preview {
    PLDialog(title: "Title",
             description: "Description",
             cancelButtonLabel: "Label",
             confirmButtonLabel: "Label") {
        print("Confirm")
    } cancelAction: {
        print("Cancel")
    }
}
