//
//  ListRunStepUseCase.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

final class ListRunStepUseCase {
    private let repository: RunStepRepository
    
    init(repository: RunStepRepository) {
        self.repository = repository
    }
    
    func execute(threadID: String, runID: String) async throws(DomainError) -> RunStepResponse {
        try await repository.listRunSteps(threadID: threadID, runID: runID)
    }
}
