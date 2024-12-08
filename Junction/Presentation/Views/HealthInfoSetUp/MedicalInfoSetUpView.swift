//
//  MedicalHistoryInfoView.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct MedicalInfoSetUpView: View {
    
    @Binding var bloodPressure: BloodPresure?
    @Binding var diabetes: Diabetes?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            bloodPressureInstruction
                .padding(.bottom, 16)
            
            bloodPressureGrid
                .padding(.bottom, 44)
            
            diabetesInstruction
                .padding(.bottom, 16)
            
            diabetesGrid
            
            
        }
    }
    
    private var bloodPressureInstruction: some View {
        Text("Do you have any blood pressure issues?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var bloodPressureGrid: some View {
        Grid {
            GridRow {
                PLFormButton(label: BloodPresure.none.rawValue,
                             isSelected: bindingForBloodPressure(BloodPresure.none),
                             contentType: .labelOnly,
                             mode: .stretch)
                .gridCellColumns(2)
                .onTapGesture { bloodPressure = BloodPresure.none }
            }
            
            GridRow {
                PLFormButton(label: BloodPresure.hypotension.rawValue,
                             isSelected: bindingForBloodPressure(BloodPresure.hypotension),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { bloodPressure = .hypotension }
                
                PLFormButton(label: BloodPresure.hypertension.rawValue,
                             isSelected: bindingForBloodPressure(BloodPresure.hypertension),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { bloodPressure = .hypertension }
            }
        }
    }
    
    private var diabetesInstruction: some View {
        Text("Do you have any form of diabetes?")
            .textStyle(.title1)
            .foregroundStyle(PLColor.neutral800)
    }
    
    private var diabetesGrid: some View {
        Grid {
            GridRow {
                PLFormButton(label: Diabetes.none.rawValue,
                             isSelected: bindingForDiabetes(Diabetes.none),
                             contentType: .labelOnly,
                             mode: .stretch)
                .gridCellColumns(3)
                .onTapGesture { diabetes = Diabetes.none }
            }
            
            GridRow {
                PLFormButton(label: Diabetes.type1.rawValue,
                             isSelected: bindingForDiabetes(Diabetes.type1),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.type1 }
                
                PLFormButton(label: Diabetes.type2.rawValue,
                             isSelected: bindingForDiabetes(Diabetes.type2),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.type2 }
                
                PLFormButton(label: Diabetes.gestational.rawValue,
                             isSelected: bindingForDiabetes(Diabetes.gestational),
                             contentType: .labelOnly,
                             mode: .stretch)
                .onTapGesture { diabetes = Diabetes.gestational }
            }
        }
    }
    
    private func bindingForBloodPressure(_ bloodPressure: BloodPresure) -> Binding<Bool> {
        Binding(
            get: { self.bloodPressure == bloodPressure },
            set: { isSelected in
                self.bloodPressure = isSelected ? bloodPressure : nil
            }
        )
    }
    
    private func bindingForDiabetes(_ diabetes: Diabetes) -> Binding<Bool> {
        Binding(
            get: { self.diabetes == diabetes },
            set: { isSelected in
                self.diabetes = isSelected ? diabetes : nil
            }
        )
    }
    
}

#Preview {
    @Previewable @State var bloodPressure: BloodPresure?
    @Previewable @State var diabetes: Diabetes?
    
    MedicalInfoSetUpView(bloodPressure: $bloodPressure, diabetes: $diabetes)
}
