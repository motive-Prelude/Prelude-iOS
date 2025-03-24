//
//  AssistantInteractionFacadeImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import UIKit

class AssistantInteractionFacadeImpl: AssistantInteractionFacade {
    
    private let createThreadAndRunUseCase: CreateThreadAndRunUseCase
    private let listRunStepUseCase: ListRunStepUseCase
    private let retrieveMessageUseCase: RetrieveMessageUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let perplexityChatUseCase: PerplexityChatUseCase
    private let geminiChatRepository = GeminiChatRepository(apiClient: APIClient())
    
    private var foodNameAssistantID: String {
        guard let assistantID = Bundle.main.object(forInfoDictionaryKey: "ASSISTANT_ID_FIND_FOOD_NAME") as? String else { return "" }
        return assistantID
    }
    
    @Published var errorMessage: String?
    
    init(createThreadAndRunUseCase: CreateThreadAndRunUseCase,
         listRunStepUseCase: ListRunStepUseCase,
         retrieveMessageUseCase: RetrieveMessageUseCase,
         uploadImageUseCase: UploadImageUseCase,
         perplexityChatUseCase: PerplexityChatUseCase) {
        self.createThreadAndRunUseCase = createThreadAndRunUseCase
        self.listRunStepUseCase = listRunStepUseCase
        self.retrieveMessageUseCase = retrieveMessageUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.perplexityChatUseCase = perplexityChatUseCase
    }
    
    public func interact(with foodName: String = "", image: UIImage?, healthInfo: HealthInfo?) async throws(DomainError) -> (Judgement, [Citation]) {
        let findingFoodNamePrompt = PromptGenerator.shared.generateFindingFoodNamePrompt()
        let findingFoodNutritionPrompt = PromptGenerator.shared.generateFindingFoodNutritionPrompt()
        let foodSafetyPrompt = PromptGenerator.shared.generateMedicalInformationPrompt(healthInfo: healthInfo)
        let jsonPostProcessingPrompt = PromptGenerator.shared.generateJSONPostProcessingPrompt()
        
        do {
            guard let result = try await geminiChatRepository.fetch(image: image, messages: [findingFoodNamePrompt, findingFoodNutritionPrompt, foodSafetyPrompt, jsonPostProcessingPrompt]) else { throw DomainError.serverError }
            let cleanedJSON = result.answer
                .replacingOccurrences(of: "`", with: "")
                .replacingOccurrences(of: "json", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "* ", with: "")
                .replacingOccurrences(of: "*", with: "")
            
            let answerData = cleanedJSON.data(using: .utf8)!
            
            let judgement = try JSONDecoder().decode(Judgement.self, from: answerData)
            return (judgement, result.citations)
        } catch { throw .serverError }
    }
    
    private func waitForMessageID(threadID: String, runID: String, maxAttempts: Int = 10, delayInSeconds: TimeInterval = 1.0) async throws(DomainError) -> String {
        var attempts = 0
        
        while attempts < maxAttempts {
            let runStepResponse = try await listRunStepUseCase.execute(threadID: threadID, runID: runID)
            
            if let messageID = runStepResponse.data.first?.stepDetails.messageCreation?.messageId {
                return messageID
            } else {
                attempts += 1
                print("MessageID is not ready. Retrying... (\(attempts))")
                try? await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
            }
        }
        
        throw .timeout
    }
    
    private func waitForMessage(threadID: String, messageID: String, maxAttempts: Int = 10, delayInSeconds: TimeInterval = 1.0) async throws(DomainError) -> String {
        var attempts = 0
        
        while attempts < maxAttempts {
            let retrieveMessageResponse = try await retrieveMessageUseCase.execute(threadID: threadID, messageID: messageID)
            
            if let message = retrieveMessageResponse.content.first?.text.value { return message }
            else {
                attempts += 1
                print("Message is not ready. Retrying... (\(attempts))")
                try? await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
            }
        }
        
        throw .timeout
    }
}
