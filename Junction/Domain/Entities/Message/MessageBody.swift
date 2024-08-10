//
//  MessageBody.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

struct MessageBody: Codable {
    var messages: [MessageContent]
}

struct MessageContent: Codable {
    let role: String
    let content: String
    }
