//
//  Judgement.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Foundation

struct Judgement: Decodable, Hashable {
    let productName: String
    let recognition: Bool
    let safetyAssessment: Bool
    let details: [JudgementDetail]
    let conclusion: String
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case recognition = "vision_recognition"
        case safetyAssessment = "safety_assessment"
        case details
        case conclusion
    }
}

struct JudgementDetail: Decodable, Hashable {
    let title: String
    let content: String
}
