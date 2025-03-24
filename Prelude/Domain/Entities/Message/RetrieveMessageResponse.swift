//
//  RetrieveMessageResponse.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct RetrieveMessageResponse: Codable {
    let content: [Content]
    
    struct Content: Codable {
        let text: Text
        
        struct Text: Codable {
            let value: String
        }
    }
}
