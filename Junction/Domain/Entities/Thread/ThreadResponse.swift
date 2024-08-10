//
//  APIResponse.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct ThreadResponse: Codable {
    let id: String
    let object: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
    }
}
