//
//  Judgement.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Foundation

struct Judgement: Decodable, Hashable {
    var foodName: String
    let safetyAssessment: String
    let nutritionDetail: [NutritionDetail]
    
    enum CodingKeys: String, CodingKey {
        case foodName = "food"
        case safetyAssessment = "is_safe"
        case nutritionDetail = "nutrition"
    }
}

struct NutritionDetail: Codable, Hashable {
    let nutrient: String
    let value: String
    let description: String
}
