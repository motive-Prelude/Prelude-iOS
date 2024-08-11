//
//  MessageRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

final class MessageRepositoryImpl: MessageRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createMessage(threadID: String, text: String?, fileId: String?) -> AnyPublisher<CreateMessageResponse, Error> {
        let body = apiService.createMessageBody(role: "user", text: text, fileId: fileId)
        
        guard let request = apiService.createRequest(withURL: EndPoint.messages(threadID: threadID).urlString, body: body as MessageBody) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            
        }
        
        return apiService.fetchData(with: request)
    }
    
    
    func retrieveMessage(threadID: String, messageID: String) -> AnyPublisher<RetrieveMessageResponse, any Error> {
        guard let request = apiService.createRequest(withURL: EndPoint.retrieveMessage(threadID: threadID, messageID: messageID).urlString, method: "GET", body: nil as String?) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return apiService.fetchData(with: request)
    }
}
