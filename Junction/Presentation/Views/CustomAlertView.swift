//
//  CustomAlertView.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        VStack {
            Text(alertManager.alertTitle)
                .font(.headline)
            
            Text(alertManager.alertMessage)
                .font(.subheadline)
            
            ForEach(alertManager.alertActions, id: \.id) { action in
                Button {
                    action.action()
                    alertManager.hideAlert()
                } label: {
                    Text(action.title)
                }
            }
            
        }
        .padding()
        .background { Color.gray }
    }
}

#Preview {
    CustomAlertView()
}
