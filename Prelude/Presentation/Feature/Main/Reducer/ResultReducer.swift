//
//  ResultFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/15/25.
//

import ComposableArchitecture
import SwiftUI

struct NutritionalAssessmentReport: Decodable {
    
}

@Reducer
struct ResultReducer {
    
    @ObservableState
    struct State {
        @Shared var user: UserInfo?
        var alert: AlertState<Action>?
        let foodImage: UIImage
        let foodInformation: FoodInformation
        var report: NutritionalAssessmentReport?
        var isLoading = true
        var retryLimit = -1
        var procedure = 1
    }
    
    enum Action: BindableAction {
        case onAppear
        
        case fetchUserInfo(String)
        case fetchUserInfoResponse(Result<UserInfo, DomainError>)
        
        case checkRemainingTimes
        
        case diagnose
        case diagnoseResponse(Result<NutritionalAssessmentReport, DomainError>)
        
        case navigateToMain
        
        case backButtonTapped
        case nextProcedure
        case binding(BindingAction<State>)
        
        indirect case setAlert(AlertEvent, Action, Action)
        case alert(Alert)
        
        enum Alert {
            case lowSeed
            case retry
            case dismiss
        }
        
    }
    
    @Dependency(\.fetchUserInfoUseCase) var fetchUserInfoUseCase
    @Dependency(\.diagnoseFoodUseCase) var diagnoseFood
    @Dependency(\.promptGenerator) var promptGenerator
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.alertStateResolver) var alertStateResolver
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onAppear:
                    state.isLoading = true
                    guard let id = state.user?.id else { return .send(.diagnoseResponse(.failure(.userNotFound))) }
                    return .send(.fetchUserInfo(id))
                    
                case .fetchUserInfo(let id):
                    return .run { send in
                        do {
                            let newUserInfo = try await fetchUserInfoUseCase.execute(userID: id)
                            await send(.nextProcedure)
                            await send(.fetchUserInfoResponse(.success(newUserInfo)))
                        } catch let error as DomainError { await send(.fetchUserInfoResponse(.failure(error))) }
                    }
                    
                case .fetchUserInfoResponse(.success(let user)):
                    state.$user.withLock { $0 = user }
                    return .send(.checkRemainingTimes)
                    
                case .fetchUserInfoResponse(.failure(let error)):
                    return .send(.setAlert(.error(error), .alert(.retry), .alert(.dismiss)))
                
                case .checkRemainingTimes:
                    guard let user = state.user else { return .send(.diagnoseResponse(.failure(.userNotFound))) }
                    guard user.remainingTimes > 0 else {
                        return .send(.setAlert(.error(.insufficientCurrency), .alert(.lowSeed), .alert(.dismiss)))
                    }
                    
                    return .send(.diagnose)
                
                case .nextProcedure:
                    state.procedure += 1
                    return .none
                    
                case .diagnose:
                    guard let healthInfo = state.user?.healthInfo else { return .send(.diagnoseResponse(.failure(.invalidArgument))) }
                    if state.retryLimit >= 3 { return .send(.diagnoseResponse(.failure(.tooManyRequests))) }
                    let foodInformation = state.foodInformation
                    let foodImage = state.foodImage
                    
                    
                    return .run { send in
                        let prompt = promptGenerator.generateDiagnosePrompt(foodInformation: foodInformation, healthInfo: healthInfo)
                        await send(.nextProcedure)
                                   
                        do {
                            let report = try await diagnoseFood.execute(image: foodImage, messages: [prompt])
                            await send(.diagnoseResponse(.success(report)))
                        } catch let error as DomainError { await send(.diagnoseResponse(.failure(error))) }
                    }
                    
                case .diagnoseResponse(.success(let report)):
                    state.report = report
                    state.isLoading = false
                    return .none
                    
                case .diagnoseResponse(.failure(let error)):
                    return .send(.setAlert(.error(error), .alert(.retry), .alert(.dismiss)))
                    
                case .alert(.retry):
                    state.retryLimit += 1
                    state.alert = nil
                    return .send(.diagnose)
                    
                case .alert(.dismiss):
                    state.alert = nil
                    return .send(.backButtonTapped)
                
                case .backButtonTapped:
                    return .send(.navigateToMain)
                    
                case .navigateToMain:
                    return .none
                    
                case .binding:
                    return .none
                    
                case let .setAlert(error, primaryAction, secondaryAction):
                    let alertState = alertStateResolver.resolve(error, primaryAction: primaryAction, secondaryAction: secondaryAction)
                    
                    state.alert = alertState
                    return .none
                    
                case .alert(.lowSeed):
                    state.alert = nil
                    return .send(.navigateToMain)
            }
        }
    }
}
