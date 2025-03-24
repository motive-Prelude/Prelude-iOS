//
//  RetrieveMessageUseCase.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

final class RetrieveMessageUseCase {
    private let repository: MessageRepository
    
    init(repository: MessageRepository) {
        self.repository = repository
    }
    
    func execute(threadID: String, messageID: String) async throws(DomainError) -> RetrieveMessageResponse {
        try await repository.retrieveMessage(threadID: threadID, messageID: messageID)
    }
}
