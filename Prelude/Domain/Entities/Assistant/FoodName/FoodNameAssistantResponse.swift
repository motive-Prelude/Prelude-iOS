//
//  FoodNameAssistantResponse.swift
//  Prelude
//
//  Created by 송지혁 on 1/16/25.
//

import Foundation

struct FoodNameAssistantResponse: Codable {
    let foodName: String
    
    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
    }
}
