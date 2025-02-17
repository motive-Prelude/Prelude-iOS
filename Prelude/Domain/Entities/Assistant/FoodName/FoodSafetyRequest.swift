//
//  FoodSafetyRequest.swift
//  Prelude
//
//  Created by 송지혁 on 1/16/25.
//


struct FoodSafetyRequest: Codable {
    let foodNutrition: FoodNutritionResponse
    let healthInfo: HealthInfo
    
    enum CodingKeys: String, CodingKey {
        case foodNutrition = "food_nutrition"
        case healthInfo
    }
}
