//
//  main.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

struct ThreadAndRunBody: Codable {
    let assistantID: String
    var thread: MessageBody
    
    enum CodingKeys: String, CodingKey {
        case assistantID = "assistant_id"
        case thread
    }
}
