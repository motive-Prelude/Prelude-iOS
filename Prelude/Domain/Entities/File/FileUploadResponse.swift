//
//  FileUploadResponse.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import Foundation

struct FileUploadResponse: Decodable {
    let id: String
    let object: String
    let bytes: Int
    let createdAt: Int
    let filename: String
    let purpose: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case bytes
        case createdAt = "created_at"
        case filename
        case purpose
    }
}
