//
//  EndPoint.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Foundation

enum EndPoint {
    static let baseURL = "https://api.openai.com/v1/threads"
    
    case runs(threadID: String)
    case messages(threadID: String)
    case threads
    case specificThread(threadID: String)
    case runStep(threadID: String, runID: String)
    case retrieveMessage(threadID: String, messageID: String)
    
    var urlString: String {
        switch self {
            case .runs(let threadID):
                return "\(EndPoint.baseURL)/\(threadID)/runs"
            case .messages(let threadID):
                return "\(EndPoint.baseURL)/\(threadID)/messages"
            case .threads:
                return EndPoint.baseURL
            case .specificThread(let threadID):
                return "\(EndPoint.baseURL)/\(threadID)"
            case .runStep(threadID: let threadID, runID: let runID):
                return "\(EndPoint.baseURL)/\(threadID)/runs/\(runID)/steps"
            case .retrieveMessage(threadID: let threadID, messageID: let messageID):
                return "\(EndPoint.baseURL)/\(threadID)/messages/\(messageID)"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
