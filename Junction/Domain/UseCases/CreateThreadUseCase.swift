//
//  CreateThreadUseCase.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

final class CreateThreadUseCase {
    private let repository: ThreadRepository
    
    init(repository: ThreadRepository) {
        self.repository = repository
    }
    
    func execute(messages: [String], fileId: String) async throws -> ThreadResponse {
        try await repository.createThread(messages: messages, fileId: fileId)
    }
}
