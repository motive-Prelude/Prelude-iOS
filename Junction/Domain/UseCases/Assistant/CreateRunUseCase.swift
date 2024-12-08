//
//  CreateRunUseCase.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

final class CreateRunUseCase {
    private let repository: RunRepository
    
    init(repository: RunRepository) {
        self.repository = repository
    }
    
    func execute(threadID: String, assistantID: String) async throws -> RunResponse {
        try await repository.createRun(threadID: threadID, assistantID: assistantID)
    }
}
