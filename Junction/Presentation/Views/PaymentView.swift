//
//  PaymentView.swift
//  Junction
//
//  Created by 송지혁 on 9/20/24.
//

import SwiftUI
import StoreKit

struct PaymentView: View {
    @EnvironmentObject var store: Store
    @State private var sliderValue: Double = 0
    
    var body: some View {
        VStack {
            Text(store.value.description)
                .font(.headline)
            
            
            Slider(value: $sliderValue, in: 0...100, step: 1)
            
            Text("\(Int(sliderValue))$")
                .monospacedDigit()
            
            ForEach(store.test, id: \.self) { product in
                Text("Purchase")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background { RoundedRectangle(cornerRadius: 16).fill(.blue) }
                    .onTapGesture {
                        Task { await store.purchase(product) }
                    }
            }
        }
        .padding()
        .alert("결제 실패", isPresented: $store.showAlert) { } message: {
            Text(store.errorMessage)
        }
    }
}

#Preview {
    PaymentView()
        .environmentObject(Store())
}
