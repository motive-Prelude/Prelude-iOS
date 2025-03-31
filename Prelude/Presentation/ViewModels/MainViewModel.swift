//
//  MainViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import AppTrackingTransparency
import Combine
import UIKit
import SwiftUI

class MainViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let promptGenerator: PromptGenerator
    private let gemini: GeminiChatRepository
    
    @Published var prompt = ""
    @Published var foodName = ""
    @Published var citations: [Citation] = []
    
    init(promptGenerator: PromptGenerator = PromptGenerator()) {
        self.promptGenerator = promptGenerator
        self.gemini = GeminiChatRepository(apiClient: APIClient())
    }
    
    func bind(userSession: UserSession) {
        self.prompt = self.promptGenerator.generatePrompt(with: userSession.userInfo?.healthInfo)
        
        userSession.$userInfo
            .compactMap { $0?.healthInfo }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] healthInfo in
                guard let self = self else { return }
                self.prompt = self.promptGenerator.generatePrompt(with: healthInfo)
            }
            .store(in: &cancellables)
    }
    
    func requestTrackingAuthorizationIfNeeded() {
        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .notDetermined {
            Task { await ATTrackingManager.requestTrackingAuthorization() }
        }
    }
    
    func searchFood(_ image: UIImage?) async {
        let searchFoodPrompt = PromptGenerator.shared.generateFindingFoodNamePrompt()
        let searchNutiritionFactPrompt = PromptGenerator.shared.generateFindingFoodNutritionPrompt()
        let jsonFormatPrompt = """
            Organize the information from above precisely into the following JSON format
            Only return the JSON format—additional explanations or text are strictly prohibited.
        
            JSON FORMAT:
            {
                foodName: String
                nutritionFacts: [
                    {
                        nutrient: String
                        value: String(Must be quantitative)
                    }
                ]
            }

        """
        
        do {
            guard let result = try await gemini.fetch(image: image, messages: [searchFoodPrompt + searchNutiritionFactPrompt + jsonFormatPrompt]) else {
                EventBus.shared.errorPublisher.send(DomainError.serverError)
                return
            }
            self.foodName = result.answer
            self.citations = result.citations
            return
        } catch {
            EventBus.shared.errorPublisher.send(error)
        }
    }
    
}
