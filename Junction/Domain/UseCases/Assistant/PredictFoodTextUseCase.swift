//
//  PredictFoodTextUseCase.swift
//  Junction
//
//  Created by 송지혁 on 11/16/24.
//

import Foundation

final class PredictFoodTextUseCase {
    private let repository: TextPredictionRepository
    
    init(repository: TextPredictionRepository) {
        self.repository = repository
    }
    
    func execute(texts: [String]) -> Bool {
        repository.predictFood(texts: texts)
    }
}
