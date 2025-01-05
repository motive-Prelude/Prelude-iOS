//
//  MessageResponse.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct CreateMessageResponse: Codable {
    let id: String
    let object: String
    let createdAt: Int
    let assistantId: String?
    let threadId: String
    let runId: String?
    let role: String
    let content: [ContentPart]
    let attachments: [Attachment]
    let metadata: [String: String]
    
    struct ContentPart: Codable {
        let type: String
        let text: TextContent?
        
        struct TextContent: Codable {
            let value: String
            let annotations: [String]
        }
    }
    
    struct Attachment: Codable {
        let fileId: String
        let tools: [String]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case assistantId = "assistant_id"
        case threadId = "thread_id"
        case runId = "run_id"
        case role
        case content
        case attachments
        case metadata
    }
}
