//
//  MessageRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

final class MessageRepositoryImpl: MessageRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createMessage(threadID: String, text: String, fileId: String) async throws -> CreateMessageResponse {
        
        let body = apiService.makeMessageBody(role: "user", text: text, fileId: fileId)
        guard let url = URL(string: EndPoint.messages(threadID: threadID).urlString) else { throw URLError(.badURL) }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        let result: CreateMessageResponse = try await apiService.fetchData(with: request)
        
        return result
    }
    
    
    func retrieveMessage(threadID: String, messageID: String) async throws -> RetrieveMessageResponse {
        guard let url = URL(string: EndPoint.retrieveMessage(threadID: threadID, messageID: messageID).urlString) else { throw URLError(.badURL) }
        let request = apiService.makeURLRequest(to: url, method: .GET)
        let result: RetrieveMessageResponse = try await apiService.fetchData(with: request)
        return result
    }
}
