//
//  ThreadAndRunResponse.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

struct ThreadAndRunResponse: Codable {
    let runID: String
    let threadID: String
    
    enum CodingKeys: String, CodingKey {
        case runID = "id"
        case threadID = "thread_id"
    }
}
