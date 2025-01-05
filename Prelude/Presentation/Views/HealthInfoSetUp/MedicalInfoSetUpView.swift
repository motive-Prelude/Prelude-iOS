//
//  MedicalHistoryInfoView.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct MedicalInfoSetUpView: View {
    
    @Binding var bloodPressure: BloodPressure?
    @Binding var diabetes: Diabetes?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            bloodPressureInstruction
                .padding(.bottom, 16)
            
            BloodPressureGrid(bloodPressure: bloodPressure) { bloodPressure in self.bloodPressure = bloodPressure }
                .padding(.bottom, 44)
            
            diabetesInstruction
                .padding(.bottom, 16)
            
            DiabetesGrid(diabetes: diabetes) { diabetes in self.diabetes = diabetes }
            
            
        }
    }
    
    private var bloodPressureInstruction: some View {
        Text("Do you have any blood pressure issues?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var diabetesInstruction: some View {
        Text("Do you have any form of diabetes?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
}

#Preview {
    @Previewable @State var bloodPressure: BloodPressure?
    @Previewable @State var diabetes: Diabetes?
    
    MedicalInfoSetUpView(bloodPressure: $bloodPressure, diabetes: $diabetes)
}
