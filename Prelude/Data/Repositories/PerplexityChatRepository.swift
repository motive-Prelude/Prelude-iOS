//
//  PerplexityChatRepository.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import UIKit

final class PerplexityChatRepository: ChatRepository {
    typealias Answer = ChatAnswer
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetch(image: UIImage? = nil, messages: [String], domainFilter: [String]?) async throws(DomainError) -> ChatAnswer {
        let systemPrompt = PerplexityMessage(role: "system", content: messages[0])
        let userMessage = PerplexityMessage(role: "user", content: messages[1])
        let request = PerplexityRequest<PerplexityResponse>(endpoint: .chatCompletions(messages: [systemPrompt, userMessage], domainFilter: domainFilter ?? []))
        
        do {
            let response = try await apiClient.send(request)
            let firstChoice = response.choices.first
            let content = firstChoice?.message.content ?? ""
            let citations = response.citations
            
            return ChatAnswer(content: content, citations: citations)
        } catch { throw ErrorMapper.map(error) }
        
    }
}


struct ChatAnswer {
    let content: String
    let citations: [String]
}
