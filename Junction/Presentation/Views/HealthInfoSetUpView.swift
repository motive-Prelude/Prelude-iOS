//
//  HealthInfoSetUpView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

enum Diabetes: String, CaseIterable, Codable {
    case suffer = "당뇨 있어요"
    case notAffected = "당뇨 없어요"
}

enum BloodPresure: String, CaseIterable, Codable {
    case high = "고혈압이 있어요"
    case low = "저혈압이 있어요"
    case normal = "정상 혈압이에요"
}

enum PregnantWeek: String, CaseIterable, Codable {
    case early = "임신 초기(1~13주)"
    case mid = "임신 중기(14~27주)"
    case late = "임신 후기(28~40주)"
}

struct HealthInfoSetUpView: View {
    @StateObject private var viewModel = HealthInfoSetUpViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    let instructionText = "먼저 몇 가지\n건강 정보를 알려주세요"
    
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
            Text("다음")
                .font(.pretendBold16)
                .foregroundStyle(.offwhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(viewModel.formCheck() ? .gray9 : .gray1)
                    
                }
                .onTapGesture {
                    viewModel.submit(navigationManager: navigationManager)
                }
                .disabled(viewModel.formCheck())
                .padding(.horizontal, 24)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("맞춤 결과를 제공하기 위해 필요한 정보들이에요")
                .font(.pretendBold24)
                .foregroundStyle(.offblack)
                .lineSpacing(4)
                .frame(height: 70)
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
        .frame(height: 250)
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
            Text("현재 임신 몇 주차이신가요?")
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
            Text("몸무게와 키를 입력해주세요")
                .font(.pretendSemiBold20)
                .foregroundStyle(.offblack)
            
            HStack(spacing: 16) {
                HStack(alignment: .bottom, spacing: 4) {
                    TextField("키", text: $viewModel.height)
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
                    TextField("몸무게", text: $viewModel.weight)
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
            Text("고혈압 또는 저혈압이 있으신가요?")
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
            Text("당뇨가 있으신가요?")
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
