//
//  AssistantInteractionFacadeImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import UIKit

class AssistantInteractionFacadeImpl: AssistantInteractionFacade {
    private let geminiChatRepository = GeminiChatRepository(apiClient: APIClient())
    
    private var foodNameAssistantID: String {
        guard let assistantID = Bundle.main.object(forInfoDictionaryKey: "ASSISTANT_ID_FIND_FOOD_NAME") as? String else { return "" }
        return assistantID
    }
    
    @Published var errorMessage: String?
    
    public func interact(with foodName: String = "", image: UIImage?, healthInfo: HealthInfo?) async throws(DomainError) -> (Judgement, [Citation]) {
        let integrationPrompt = PromptGenerator.shared.integrationPrompt(healthInfo: healthInfo)
        
        do {
            guard let result = try await geminiChatRepository.fetch(image: nil, messages: [foodName + integrationPrompt]) else { throw DomainError.serverError }
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
}
