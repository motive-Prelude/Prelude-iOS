//
//  HealthInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

enum Diabetes: String, CaseIterable, Codable {
    case suffer = "Yes"
    case notAffected = "No"
}

enum BloodPresure: String, CaseIterable, Codable {
    case high = "Hypertension"
    case low = "Hypotension"
    case normal = "Fine"
}

enum PregnantWeek: String, CaseIterable, Codable {
    case early = "1~13 weeks"
    case mid = "14~27 weeks"
    case late = "28~40 weeks"
    case postpartum = "postpartum"
}

struct HealthInfoSetUpView: View {
    @StateObject private var viewModel = HealthInfoSetUpViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    let headerText = """
    These are the details we need
    to provide personalized
    results
    """
    let instructionText = """
First we need your
health information
"""
    
    var body: some View {
        ZStack {
            Color.offwhite
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            
            if viewModel.showInstructions {
                instructionView
                    .onAppear { viewModel.animateInstructionText() }
                
            } else {
                healthSetupView
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    private var instructionView: some View {
        VStack(spacing: 43) {
            Image("speechBubble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 114)
                .offset(y: viewModel.showInstructionText ? 0 : 30)
                .opacity(viewModel.showInstructionText ? 1 : 0)
            
            Text(instructionText)
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
                .multilineTextAlignment(.center)
                .offset(y: viewModel.showInstructionText ? 0 : 30)
                .opacity(viewModel.showInstructionText ? 1 : 0)
        }
    }
    
    private var healthSetupView: some View {
        VStack {
            header
            setup
            Spacer()
            Text("Next")
                .font(.pretendBold16)
                .foregroundStyle(.offwhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(viewModel.formCheck() ? .gray9 : .gray1)
                    
                }
                .onTapGesture {
                    viewModel.submit { result in
                        if case .success(let healthInfo) = result { navigationManager.screenPath.append(.healthCheck(healthInfo: healthInfo)) }
                    }
                }
                .disabled(viewModel.formCheck())
                .padding(.horizontal, 24)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(headerText)
                .font(.pretendBold24)
                .foregroundStyle(.offblack)
                .lineSpacing(4)
                .frame(height: 100)
                .padding(.top, 82)
            Spacer()
            HStack {
                Spacer()
                Image("pinky")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 111)
            }
            .padding(.trailing, 16)
        }
        .padding(.leading, 24)
        .frame(height: 260)
        .background { Color.gray10 }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
    
    private var setup: some View {
        VStack(alignment: .leading, spacing: 48) {
            pregnantWeekSelection
            bmiSelection
            bloodPressureSelection
            diabetesSelection
        }
        .padding(.top, 24)
    }
    
    private var pregnantWeekSelection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("How many weeks pregnant are you?")
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
            
            HStack(spacing: 8) {
                ForEach(PregnantWeek.allCases, id: \.self) { week in
                    Text(week.rawValue)
                        .font(.pretendMedium12)
                        .foregroundStyle(viewModel.selectedPregnantWeek == week ? .offwhite : .gray4)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                        .background {Capsule().fill(viewModel.selectedPregnantWeek == week ? .offblack:  .gray10) }
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.1)) {
                                viewModel.selectedPregnantWeek = week
                            }
                        }
                }
            }
        }
    }
    
    private var bmiSelection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("What is your height and weight?")
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
            
            HStack(spacing: 16) {
                HStack(alignment: .bottom, spacing: 4) {
                    TextField("Height", text: $viewModel.height)
                        .font(.pretendMedium16)
                        .frame(width: 82)
                        .padding(.vertical, 7)
                        .background { RoundedRectangle(cornerRadius: 8).fill(.gray10) }
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    Text("cm")
                        .font(.pretendSemiBold16)
                        .foregroundStyle(.gray2)
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    TextField("Weight", text: $viewModel.weight)
                        .font(.pretendMedium16)
                        .frame(width: 82)
                        .padding(.vertical, 7)
                        .background { RoundedRectangle(cornerRadius: 8).fill(.gray10) }
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    Text("kg")
                        .font(.pretendSemiBold16)
                        .foregroundStyle(.gray2)
                }
            }
        }
    }
    
    private var bloodPressureSelection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Any problem with your blood pressure?")
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
            
            HStack(spacing: 8) {
                ForEach(BloodPresure.allCases, id: \.self) { bloodPressure in
                    Text(bloodPressure.rawValue)
                        .font(.pretendMedium14)
                        .foregroundStyle(viewModel.selectedBloodPressure == bloodPressure ? .offwhite : .gray4)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                        .background { Capsule().fill(viewModel.selectedBloodPressure == bloodPressure ? .offblack : .gray10) }
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.1)) {
                                viewModel.selectedBloodPressure = bloodPressure
                            }
                        }
                }
            }
        }
    }
    
    private var diabetesSelection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Do you have history of diabetes?")
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
            
            HStack(spacing: 8) {
                ForEach(Diabetes.allCases, id: \.self) { diabetes in
                    Text(diabetes.rawValue)
                        .font(.pretendMedium14)
                        .foregroundStyle(viewModel.selectedDiabetes == diabetes ? .offwhite : .gray4)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                        .background { Capsule().fill(viewModel.selectedDiabetes == diabetes ? .offblack : .gray10) }
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.1)) {
                                viewModel.selectedDiabetes = diabetes
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    HealthInfoSetUpView()
}
