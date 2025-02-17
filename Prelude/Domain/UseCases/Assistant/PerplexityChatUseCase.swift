//
//  PerplexityChatUseCase.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import Foundation

final class PerplexityChatUseCase {
    private let repository: ChatRepository
    
    init(repository: ChatRepository) {
        self.repository = repository
    }
    
    func execute(messages: [String], domainFilter: [String]) async throws(DomainError) -> ChatAnswer {
        return try await repository.fetch(image: nil, messages: messages, domainFilter: domainFilter)
    }
}
