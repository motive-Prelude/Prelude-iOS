//
//  HealthCheckView.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import SwiftUI

struct HealthCheckView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    @StateObject var healthCheckViewModel = HealthCheckViewModel()
    let healthInfo: HealthInfo
    
    var body: some View {
        ZStack {
            Color.offwhite
            
            VStack {
                Spacer()
                instructions
                Image("arrowDown")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .padding(.bottom, 80)
                
                healthInformations
                Spacer()
                
                HStack(spacing: 12) {
                    Text("No, need to edit")
                        .font(.pretendBold16)
                        .foregroundStyle(.offblack)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray1, lineWidth: 1)
                                .frame(maxWidth: .infinity)
                        }
                        .onTapGesture {
                            dismiss()
                        }
                        .padding(.leading, 24)
                    
                    
                    Text("Yes")
                        .font(.pretendBold16)
                        .foregroundStyle(.offwhite)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.gray1)
                                .frame(maxWidth: .infinity)
                        }
                    
                        .onTapGesture {
                            Task {
                                await healthCheckViewModel.submit(healthInfo: healthInfo)
                                await MainActor.run { navigationManager.screenPath.append(.main) }
                            }
                        }
                        .padding(.trailing, 24)
                    
                }
                .padding(.bottom, 36)
            }
            .navigationBarBackButtonHidden()
        }
        .ignoresSafeArea()
    }
    
    private var instructions: some View {
        VStack(spacing: 4) {
            Text("All done!")
                .font(.pretendMedium16)
                .foregroundStyle(.gray8)
            
            Text("Is this correct?")
                .font(.pretendSemiBold26)
                .foregroundStyle(.offblack)
        }
    }
    
    private var healthInformations: some View {
        VStack(spacing: 9) {
            healthTags(text: healthInfo.pregnantWeek.rawValue)
            healthTags(text: "\(healthInfo.height)cm")
            healthTags(text: "\(healthInfo.weight)kg")
            healthTags(text: "\(healthInfo.bloodPressure.rawValue)")
            healthTags(text: "Diabetes \(healthInfo.diabetes.rawValue)")
        }
    }
    
    private func healthTags(text: String) -> some View {
        Text(text)
            .font(.pretendSemiBold20)
            .foregroundStyle(.offwhite)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(.offblack))
    }
}
