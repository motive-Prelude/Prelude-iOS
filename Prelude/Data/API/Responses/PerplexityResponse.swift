//
//  PerplexityResponse.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//


struct PerplexityResponse: Decodable {
    let id: String
    let citations: [String]
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: PerplexityMessage
}