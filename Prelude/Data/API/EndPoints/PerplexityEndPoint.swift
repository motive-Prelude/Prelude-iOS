//
//  PerplexityEndPoint.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import Foundation

enum PerplexityEndPoint: EndPoint {
    case chatCompletions(messages: [PerplexityMessage], domainFilter: [String])
    
    var path: String {
        switch self {
            case .chatCompletions:
                return "/chat/completions"
        }
    }
    
    var method: HTTPMethod { .POST }
    var headers: [String : String] {
        var defaultHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "PERPLEXITY_API_KEY") {
            defaultHeaders["Authorization"] = "Bearer \(apiKey)"
        }
        
        return defaultHeaders
    }
    
    var body: Data? {
        switch self {
            case .chatCompletions(let messages, let domainFilter):
                let requestBody = PerplexityRequestBody(messages: messages, domainFilter: domainFilter)
                return try? JSONEncoder().encode(requestBody)
        }
    }
}

struct PerplexityMessage: Codable {
    let role: String
    let content: String
}


struct PerplexityRequestBody: Encodable {
    let model: String = "sonar-pro"
    let messages: [PerplexityMessage]
    let domainFilter: [String]
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case domainFilter = "search_domain_filter"
    }
}

struct JSONSchema: Codable {
    let schema: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
}

struct ResponseFormat: Codable {
    let type: String
    let jsonSchema: JSONSchema?
    
    enum CodingKeys: String, CodingKey {
        case type
        case jsonSchema = "json_schema"
    }
}
