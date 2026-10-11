//
//  MainFeature.swift
//  Prelude
//
//  Created by 송지혁 on 5/12/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MainReducer {
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared var user: UserInfo?
        var foodInformation: FoodInformation?
        var foodImage: UIImage? = nil
        var foodName = ""
        var citations: [Citation] = []
    }
    
    enum Action: BindableAction {
        case imagePicked(UIImage)
        case searchFoodInformation
        case searchFoodInformationResponse(Result<(FoodInformation, [Citation]), DomainError>)
        
        case updateFoodInformation((FoodInformation, [Citation]))
        case destination(PresentationAction<Destination.Action>)
        
        case removeImage
        case retakePhoto
        
        case showSeedLowSheet
        case showImagePicker
        case showPurchaseView
        
        case purchaseButtonTapped
        case settingButtonTapped
        case searchFoodInformationButtonTapped
        case diagnoseButtonTapped
        
        
        
        case binding(BindingAction<State>)
        
        case navigateToResult(UIImage, FoodInformation)
        case navigateToSetting
        case navigationFailed(DomainError)
        
        case setToast(GlobalEvent)
    }
    
    @Reducer
    enum Destination {
        case imagePicker
        case seedlow
        case purchase(StoreReducer)
    }
    
    @Dependency(\.eventBus) var eventBus
    @Dependency(\.searchFoodInformationUseCase) var searchFoodInformationUseCase
    @Dependency(\.networkMonitor) var network
    @Dependency(\.promptGenerator) var promptGenerator
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                case .searchFoodInformationButtonTapped:
                    return .send(.searchFoodInformation)
                    
                case .diagnoseButtonTapped:
                    guard network.isConnected else { return .send(.navigationFailed(.networkUnavailable)) }
                    guard let remainingTimes = state.user?.remainingTimes else { return .send(.navigationFailed(.authenticationFailed)) }
                    if remainingTimes < 1 { return .send(.showSeedLowSheet) }
                    guard let image = state.foodImage else { return .send(.navigationFailed(.unknown)) }
                    guard let information = state.foodInformation else { return .send(.navigationFailed(.unknown)) }
                    
                    
//                        analytics.logEvent("음식 검색", parameters: ["음식 이름": foodName])
                        
                    return .concatenate(
                        .send(.navigateToResult(image, information)),
                        .send(.removeImage))
                    
                case .searchFoodInformation:
                    let image = state.foodImage
                    let namePrompt = promptGenerator.generateFindingFoodNamePrompt()
                    let nutritionPrompt = promptGenerator.generateFindingFoodNutritionPrompt()
                    let jsonFormatPrompt = promptGenerator.generateJSONFormatPrompt()
                    
                    guard network.isConnected else { return .send(.searchFoodInformationResponse(.failure(.networkUnavailable))) }
                    
                    return .run { send in    
                        do {
                            let response = try await searchFoodInformationUseCase.execute(image: image, messages: [namePrompt + nutritionPrompt + jsonFormatPrompt])
                            await send(.searchFoodInformationResponse(.success(response)))
                        } catch let error as DomainError { await send(.searchFoodInformationResponse(.failure(error))) }
                    }
                    
                case .searchFoodInformationResponse(.success(let info)):
                    return .send(.updateFoodInformation(info))
                    
                case .searchFoodInformationResponse(.failure(let error)):
                    return .send(.setToast(.toast(.error(error))))

                case .setToast(let event):
                    return .run { _ in
                        await eventBus.send(event)
                    }
                    
                case .showImagePicker:
                    state.destination = .imagePicker
                    return .none
                    
                case .imagePicked(let image):
                    state.foodImage = image
                    return .none
                    
                case .removeImage:
                    withAnimation(.linear(duration: 0.2)) {
                        state.foodImage = nil
                    }
                    
                    return .none
                    
                case .retakePhoto:
                    return .send(.showImagePicker)
                    
                case .showSeedLowSheet:
                    state.destination = .seedlow
                    return .none
                
                case .showPurchaseView:
                    state.destination = .purchase(StoreReducer.State())
                    return .none
                    
                case .navigateToSetting:
                    return .none
                
                case .navigateToResult:
                    return .none
                    
                case .updateFoodInformation(let info):
                    state.foodInformation = info.0
                    state.citations = info.1
                    
                    return .none
                    
                case .destination: return .none
                    
                case .binding: return .none
                    
                case .purchaseButtonTapped:
                    return .send(.showPurchaseView)
                    
                case .settingButtonTapped:
                    return .send(.navigateToSetting)
                    
                case .navigationFailed(let error):
                    return .send(.setToast(.toast(.error(error))))
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
        
}
