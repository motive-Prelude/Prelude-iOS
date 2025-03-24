//
//  MessageBody.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

//struct MessageBody: Codable {
//    var messages: [MessageContent]
//}
//
//struct MessageContent: Codable {
//    let role: String
//    let content: String
//}

struct MessageBody: Codable {
    var messages: [MessageContent]
}

struct MessageContent: Codable {
    let role: String
    let content: [MessageContentData]
}

struct MessageContentData: Codable {
    let type: String
    let text: String?
    let imageFile: ImageFileContent?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageFile = "image_file"
    }
}

struct ImageFileContent: Codable {
    let fileID: String
    let detail: String?
    
    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case detail
    }
}
