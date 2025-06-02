//
//  FoodInformation.swift
//  Prelude
//
//  Created by 송지혁 on 5/16/25.
//

struct FoodInformation: Decodable {
    let name: String
    let summary: String
    let ingredient: [String]
    let nutritions: [String]
}
