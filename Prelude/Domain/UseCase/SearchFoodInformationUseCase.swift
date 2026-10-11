//
//  DiagnoseFoodUseCase 2.swift
//  Prelude
//
//  Created by 송지혁 on 5/13/25.
//

import UIKit

final class SearchFoodInformationUseCase {
    private let repository: ChatAIRepository
    
    init(repository: ChatAIRepository) {
        self.repository = repository
    }
    
    func execute(image: UIImage?, messages: [String]) async throws(DomainError) -> (FoodInformation, [Citation]) {
        let response = try await repository.fetch(image: image, messages: messages, as: FoodInformation.self)
        
        return response
    }
}
