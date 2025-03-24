//
//  EndPoint.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Foundation

enum OpenAIEndPoint {
    static let baseURL = "https://api.openai.com/v1/threads"
    static let imageBaseURL = "https://api.openai.com/v1/files"
    
    case runs(threadID: String)
    case messages(threadID: String)
    case threads
    case specificThread(threadID: String)
    case runStep(threadID: String, runID: String)
    case retrieveMessage(threadID: String, messageID: String)
    case uploadFile
    case threadsAndRun
    
    var urlString: String {
        switch self {
            case .runs(let threadID):
                return "\(OpenAIEndPoint.baseURL)/\(threadID)/runs"
            case .messages(let threadID):
                return "\(OpenAIEndPoint.baseURL)/\(threadID)/messages"
            case .threads:
                return OpenAIEndPoint.baseURL
            case .specificThread(let threadID):
                return "\(OpenAIEndPoint.baseURL)/\(threadID)"
            case .runStep(threadID: let threadID, runID: let runID):
                return "\(OpenAIEndPoint.baseURL)/\(threadID)/runs/\(runID)/steps"
            case .retrieveMessage(threadID: let threadID, messageID: let messageID):
                return "\(OpenAIEndPoint.baseURL)/\(threadID)/messages/\(messageID)"
            case .uploadFile:
                return "\(OpenAIEndPoint.imageBaseURL)"
            case .threadsAndRun:
                return "\(OpenAIEndPoint.baseURL)/runs"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
