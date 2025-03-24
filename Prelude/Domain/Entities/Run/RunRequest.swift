//
//  RunRequest.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct RunRequest: Codable {
    let assistantID: String
    
    enum CodingKeys: String, CodingKey {
        case assistantID = "assistant_id"
    }
}
