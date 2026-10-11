//
//  HealthInfoSetupFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct HealthInfoSetupReducer {
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        var currentPage = 0
        var gestationalWeek: GestationalWeek? = nil
        var height: Height? = nil
        var weight: Weight? = nil
        var bloodPressure: BloodPressure? = nil
        var diabetes: Diabetes? = nil
        var allergies: [Allergies] = []
        
        var isButtonDisabled: Bool = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case backButtonTapped
        case nextButtonTapped
        case skipButtonTapped
        case saveButtonTapped
        
        case setGestationalWeek(GestationalWeek)
        case setHeight(Height)
        case setWeight(Weight)
        case setBloodPressure(BloodPressure)
        case setDiabetes(Diabetes)
        case setAllergies([Allergies])
        
        case navigateToHealthSetupConfirm(HealthInfo)
        case navigateToDisclaimer
    }
    
    @Dependency(\.saveUserInfoUseCase) var saveUserInfoUseCase
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .backButtonTapped:
                    if state.currentPage > 0 { state.currentPage -= 1 }
                    return .none
                    
                case .nextButtonTapped:
                    withAnimation(.linear) {
                        if state.currentPage < TabSelection.allCases.count - 1 {
                            state.currentPage += 1
                        }
                    }
                    return .none
                    
                case .skipButtonTapped:
                    return .send(.navigateToDisclaimer)
                    
                case .saveButtonTapped:
                    let healthInfo = HealthInfo(
                        id: UUID().uuidString,
                        gestationalWeek: state.gestationalWeek ?? .noResponse,
                        height: state.height?.value ?? 0.0,
                        weight: state.weight?.value ?? 0.0,
                        lastHeightUnit: state.height?.unit ?? .centimeter,
                        lastWeightUnit: state.weight?.unit ?? .kilogram,
                        bloodPressure: state.bloodPressure ?? .noResponse,
                        diabetes: state.diabetes ?? .noResponse,
                        restrictions: state.allergies
                    )

                    return .send(.navigateToHealthSetupConfirm(healthInfo))
                    
                case .setGestationalWeek(let week):
                    state.gestationalWeek = week
                    return .none
                    
                case .setHeight(let height):
                    state.height = height
                    return .none
                    
                case .setWeight(let weight):
                    state.weight = weight
                    return .none
                    
                case .setBloodPressure(let bloodPressure):
                    state.bloodPressure = bloodPressure
                    return .none
                    
                case .setDiabetes(let diabetes):
                    state.diabetes = diabetes
                    return .none
                    
                case .setAllergies(let allergy):
                    state.allergies = allergy
                    return .none
                    
                case .navigateToDisclaimer:
                    return .none
                    
                case .navigateToHealthSetupConfirm:
                    return .none
                case .binding(_):
                    return .none
            }
        }
    }
}
