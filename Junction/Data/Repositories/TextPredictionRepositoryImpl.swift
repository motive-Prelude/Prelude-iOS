//
//  TextPredictionRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/15/24.
//

import Foundation

final class TextPredictionRepositoryImpl: TextPredictionRepository {
    private let model: FoodTextDetection
    
    init(model: FoodTextDetection) {
        self.model = model
    }
    
    func predictFood(texts: [String]) -> Bool {
        for word in texts {
            print("추출된 단어: \(word)")
            guard let prediction = try? model.prediction(text: word) else { return false }
            print("예측 결과값: \(prediction.label)")
            if prediction.label == "food" {
                print("추출된 단어 \(word)는 음식이다.")
                return true
            }
        }
        
        return false
    }
}
