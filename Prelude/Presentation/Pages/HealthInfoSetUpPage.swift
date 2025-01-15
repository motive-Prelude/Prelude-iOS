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
    
    @State private var currentPage = 0
    @State private var buttonDisabled = false
    
    @State private var gestationalWeek: GestationalWeek?
    @State private var height: Height?
    @State private var weight: Weight?
    
    @State private var bloodPressure: BloodPressure?
    @State private var diabetes: Diabetes?
    @State private var allergies: [Allergies] = []
    
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.plTypographySet) var typographies
    
    var body: some View {
        StepTemplate(backgroundColor: PLColor.neutral50, contentTopPadding: 44) {
            navigationHeader
            headline
        } content: {
            VStack(spacing: 0) {
                tabs
                Spacer()
                pageIndicator
                    .padding(.bottom, 16)
            }
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
            PLActionButton(label: Localization.Button.skipButtonTitle,
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
                .textStyle(typographies.heading2)
                .foregroundStyle(PLColor.neutral800)
                .multilineTextAlignment(.center)
        }
    }
    
    private func headLineTitle(_ currentPage: Int) -> String {
        
        
        switch currentPage {
            case 1: return Localization.Label.basicInfoTitle
            case 2: return Localization.Label.medicalHistoryTitle
            case 3: return Localization.Label.allergyTitle
            case 4: return Localization.Label.confirmTitle
            default: return ""
        }
    }
    
    private var tabs: some View {
        VStack {
            switch TabSelection(rawValue: currentPage+1) {
                case .basic:
                    BasicInfoSetUpView(gestationalWeek: $gestationalWeek, height: $height, weight: $weight)
                        .trackScreen(screenName: "건강 정보 입력 뷰 1")
                    
                case .medicalHistory:
                    MedicalInfoSetUpView(bloodPressure: $bloodPressure,
                                         diabetes: $diabetes)
                    .trackScreen(screenName: "건강 정보 입력 뷰 2")
                    
                case .allergies:
                    AllergiesInfoSetUpView(allergies: $allergies)
                        .trackScreen(screenName: "건강 정보 입력 뷰 3")
                    
                default: EmptyView()
            }
            
            Spacer()
        }
    }
    
    private var pageIndicator: some View {
        PLPageIndicator(currentPage: $currentPage, totalCount: TabSelection.totalCount)
    }
    
    private var button: some View {
        PLActionButton(label: Localization.Button.nextButtonTitle,
                       type: .primary,
                       contentType: .text,
                       size: .large,
                       shape: .rect) { currentPage == TabSelection.totalCount - 1 ? saveFinalData() : nextPage()
        }
    }
    
    private func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
        else { navigationManager.previous() }
    }
    
    private func nextPage() {
        if currentPage < TabSelection.totalCount - 1 { currentPage += 1 }
    }
    
    private func saveFinalData() {
        let healthInfo = createHealthInfo()
        navigationManager.navigate(.healthInfoConfirm(healthInfo: healthInfo, contentMode: .passive))
    }
    
    private func createHealthInfo() -> HealthInfo {
        return HealthInfo(id: UUID().uuidString,
                          gestationalWeek: gestationalWeek ?? .noResponse,
                          height: height?.value ?? 0.0,
                          weight: weight?.value ?? 0.0,
                          lastHeightUnit: height?.unit ?? .centimeter,
                          lastWeightUnit: weight?.unit ?? .kilogram,
                          bloodPressure: bloodPressure ?? .noResponse,
                          diabetes: diabetes ?? .noResponse,
                          restrictions: allergies)
    }
}

#Preview {
    HealthInfoSetUpPage()
        .environmentObject(NavigationManager())
}
