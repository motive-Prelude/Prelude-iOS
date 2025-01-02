//
//  BmiTextFields.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct BmiTextFields: View {
    @State private var height: Height?
    @State private var weight: Weight?
    
    let result: (Height?, Weight?) -> ()
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            PLInputField(leftUnit: HeightUnit.centimeter, rightUnit: HeightUnit.feet) { height in self.height = height }
                .padding(.bottom, 8)
            
            PLInputField(leftUnit: WeightUnit.kilogram, rightUnit: WeightUnit.pound) { weight in self.weight = weight }
        }
        .onChange(of: height) { _, _ in
            result(height ,weight)
        }
        .onChange(of: weight) { _, _ in
            result(height, weight)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    BmiTextFields() { height, weight in }
}
