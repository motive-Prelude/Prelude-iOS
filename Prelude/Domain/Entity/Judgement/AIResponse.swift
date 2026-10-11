//
//  AIResponse.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//


struct AIResponse: Decodable {
    let answer: String
    let citations: [Citation]
}
