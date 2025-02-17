//
//  GeminiEndPoint.swift
//  Prelude
//
//  Created by 송지혁 on 2/7/25.
//

import Foundation

enum GeminiEndPoint: EndPoint {
    case chat(prompt: [String], image: String)
    
    var path: String {
        switch self {
            default: return ""
        }
    }
    
    var method: HTTPMethod { .POST }
    
    var headers: [String : String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }
    
    var body: Data? {
        switch self {
            case .chat(let prompt, let image):
                let requestBody = GeminiRequestBody(prompt: prompt, image: image)
                return try? JSONEncoder().encode(requestBody)
        }
    }

}


struct GeminiRequestBody: Encodable {
    let prompt: [String]
    let image: String
}

struct GeminiResponse: Decodable {
    let answer: String
    let citations: [Citation]
}

struct Citation: Decodable, Hashable {
    let title: String
    let url: String
}
