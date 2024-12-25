//
//  HealthInfoSetUpPage.swift
//  Junction
//
//  Created by 송지혁 on 12/1/24.
//

import SwiftUI

struct HealthInfoSetUpPage: View {
    enum TabSelection: Int, CaseIterable, Hashable {
        case basic = 1
        case medicalHistory
        case allergies
        
        static var totalCount: Int { allCases.count }
    }
    
    @State private var currentPage: Int = 0
    @State private var buttonDisabled = false
    
    @State private var gestationalWeek: GestationalWeek?
    @State private var height: Double = 0.0
    @State private var weight: Double = 0.0
    
    @State private var heightValues: [HeightUnit: Double] = [:]
    @State private var weightValues: [WeightUnit: Double] = [:]
    @State private var heightLeftSelected = true
    @State private var weightLeftSelected = true
    
    @State private var bloodPressure: BloodPressure?
    @State private var diabetes: Diabetes?
    @State private var allergies = Array(repeating: false, count: Allergies.totalCount)
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        InfoStepTemplate(backgroundColor: PLColor.neutral50) {
                navigationHeader
                headline
        } content: {
                tabs
                Spacer()
                pageIndicator
                .padding(.bottom, 16)
        } buttons: { button }
    }
    
    private var navigationHeader: some View {
        PLNavigationHeader("") {
            PLActionButton(icon: Image(.back),
                           type: .secondary,
                           contentType: .icon,
                           size: .small,
                           shape: .square) { previousPage() }
        } trailing: {
            PLActionButton(label: "Skip",
                           type: .secondary,
                           contentType: .text,
                           size: .medium,
                           shape: .none) {
                withAnimation(.linear) { nextPage() }
            }
        }
    }
        
    private var headline: some View {
        VStack(spacing: 8) {
            Image("Page\(currentPage+1)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
            
            Text(headLineTitle(currentPage+1))
                .textStyle(.heading2)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.center)
        }
    }
    
    private func headLineTitle(_ currentPage: Int) -> String {
        switch currentPage {
            case 1: return "Basic Info"
            case 2: return "Medical History"
            case 3: return "Allergies And\nDietary Restrictions"
            case 4: return "Is this correct?"
            default: return ""
        }
    }
    
    private var tabs: some View {
        VStack {
            switch TabSelection(rawValue: currentPage+1) {
                case .basic:
                    BasicInfoSetUpView(gestationalWeek: $gestationalWeek,
                                       heightValues: $heightValues,
                                       weightValues: $weightValues,
                                       heightLeftSelected: $heightLeftSelected,
                                       weightLeftSelected: $weightLeftSelected)
                    
                case .medicalHistory:
                    MedicalInfoSetUpView(bloodPressure: $bloodPressure,
                                         diabetes: $diabetes)
                    
                case .allergies:
                    AllergiesInfoSetUpView(allergies: $allergies)
                    
                default: EmptyView()
            }
            
            Spacer()
        }
    }
    
    private var pageIndicator: some View {
        PLPageIndicator(currentPage: $currentPage, totalCount: TabSelection.totalCount)
    }
    
    private var button: some View {
        PLActionButton(label: "Next",
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect) { currentPage == TabSelection.totalCount - 1 ? saveFinalData() : nextPage()
        }
    }
    
    private func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }
    
    private func calculatedHeight() -> Double {
        heightValues.reduce(0.0) { total, entry in
            total + entry.key.toBaseUnit(entry.value)
        }
    }
    
    private func calculatedWeight() -> Double {
        weightValues.reduce(0.0) { total, entry in
            total + entry.key.toBaseUnit(entry.value)
        }
    }
    
    private func nextPage() {
        if currentPage < TabSelection.totalCount - 1 { currentPage += 1 }
    }
    
    private func saveFinalData() {
        height = calculatedHeight()
        weight = calculatedWeight()
        navigationManager.navigate(.healthInfoEdit(healthInfo: createHealthInfo(), contentMode: .passive))
    }
    
    private func createHealthInfo() -> HealthInfo {
        return HealthInfo(id: "",
            gestationalWeek: gestationalWeek ?? .noResponse,
            height: height,
            weight: weight,
            lastHeightUnit: heightValues.first?.key ?? .centimeter,
            lastWeightUnit: weightValues.first?.key ?? .kilogram,
            bloodPressure: bloodPressure ?? .noResponse,
            diabetes: diabetes ?? .noResponse,
            restrictions: allergies.enumerated().compactMap { $0.element ? Allergies.allCases[$0.offset] : nil }
        )
    }
}

#Preview {
    HealthInfoSetUpPage()
        .environmentObject(NavigationManager())
}
