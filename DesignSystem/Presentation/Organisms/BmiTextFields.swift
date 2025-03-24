//
//  BmiTextFields.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct BmiTextFields: View {
    @State var height: Height?
    @State var weight: Weight?
    
    let result: (Height?, Weight?) -> ()
    
    var heightValue: [Height.Unit: Height.Value] {
        guard let height else { return [:] }
        return [height.unit: height.value]
    }
    
    var weightValue: [Weight.Unit: Weight.Value] {
        guard let weight else { return [:] }
        return [weight.unit: weight.value]
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            PLInputField(value: heightValue, leftUnit: HeightUnit.centimeter, rightUnit: HeightUnit.feet) { height in self.height = height }
                .padding(.bottom, 8)
            
            PLInputField(value: weightValue, leftUnit: WeightUnit.kilogram, rightUnit: WeightUnit.pound) { weight in self.weight = weight }
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
