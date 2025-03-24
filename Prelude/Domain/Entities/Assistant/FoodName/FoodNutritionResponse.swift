//
//  FoodNutritionResponse.swift
//  Prelude
//
//  Created by 송지혁 on 1/16/25.
//

import Foundation

struct FoodNutritionResponse: Codable {
    let name: String
    let nutritionInfo: [NutritionInfo]
    
    enum CodingKeys: String, CodingKey {
        case name
        case nutritionInfo = "nutrition_info"
    }
}

struct NutritionInfo: Codable {
    let nutrient: String
    let value: String
}
