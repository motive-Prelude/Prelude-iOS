//
//  MessageRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

final class MessageRepositoryImpl: MessageRepository {
    private let apiService: APIClient
    
    init(apiService: APIClient) {
        self.apiService = apiService
    }
    
    func createMessage(threadID: String, text: String, fileId: String) async throws(DomainError) -> CreateMessageResponse {
        
        let body = apiService.makeMessageBody(role: "user", text: text, fileId: fileId)
        guard let url = URL(string: OpenAIEndPoint.messages(threadID: threadID).urlString) else { throw .unknown }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        
        do {
            let result: CreateMessageResponse = try await apiService.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
    }
    
    
    func retrieveMessage(threadID: String, messageID: String) async throws(DomainError) -> RetrieveMessageResponse {
        guard let url = URL(string: OpenAIEndPoint.retrieveMessage(threadID: threadID, messageID: messageID).urlString) else { throw .unknown }
        let request = apiService.makeURLRequest(to: url, method: .GET)
        
        do {
            let result: RetrieveMessageResponse = try await apiService.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
    }
}
