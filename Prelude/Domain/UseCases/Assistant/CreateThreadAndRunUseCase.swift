//
//  CreateAndRunUseCase.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

final class CreateThreadAndRunUseCase {
    private let repository: CreateThreadAndRunRepository
    
    init(repository: CreateThreadAndRunRepository) {
        self.repository = repository
    }
    
    func execute(assistantID: String, messages: [String], fileID: String) async throws(DomainError) -> ThreadAndRunResponse {
        return try await repository.createThreadAndRun(assistantID: assistantID, messages: messages, fileID: fileID)
        
        
    }
}
