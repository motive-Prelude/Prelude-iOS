//
//  DetectFoodUseCase.swift
//  Junction
//
//  Created by 송지혁 on 11/9/24.
//

import UIKit

final class PredictFoodUseCase {
    private let repository: ImagePredictionRepository
    
    init(repository: ImagePredictionRepository) {
        self.repository = repository
    }
    
    func execute(with image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        repository.predictFood(from: image) { result in
            completion(result)
        }
    }
}
