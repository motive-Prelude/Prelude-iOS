//
//  TextPredictionRepository.swift
//  Junction
//
//  Created by 송지혁 on 11/15/24.
//

import Foundation

protocol TextPredictionRepository {
    func predictFood(texts: [String]) -> Bool
}
