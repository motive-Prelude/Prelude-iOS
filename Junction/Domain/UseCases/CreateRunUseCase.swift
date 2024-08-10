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
    
    func execute(threadID: String, assistantID: String) -> AnyPublisher<RunResponse, Error> {
        return repository.createRun(threadID: threadID, assistantID: assistantID)
    }
}
