//
//  DiagnoseFoodUsecase.swift
//  Prelude
//
//  Created by 송지혁 on 5/12/25.
//

import UIKit

final class DiagnoseFoodUseCase {
    private let repository: ChatAIRepository
    
    init(repository: ChatAIRepository) {
        self.repository = repository
    }
    
    func execute(image: UIImage?, messages: [String]) async throws(DomainError) -> NutritionalAssessmentReport {
        try await repository.fetch(image: image, messages: messages, as: NutritionalAssessmentReport.self)
        
        return NutritionalAssessmentReport()
    }
}
