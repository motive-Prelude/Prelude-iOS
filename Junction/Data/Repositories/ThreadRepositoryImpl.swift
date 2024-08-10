//
//  ThreadRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

final class ThreadRepositoryImpl: ThreadRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createThread(messages: [String]) -> AnyPublisher<ThreadResponse, Error> {
        let body = apiService.createThreadBody(role: "user", messages: messages)
        
        guard let request = apiService.createRequest(withURL: EndPoint.threads.urlString, body: body as MessageBody) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        
        return apiService.fetchData(with: request)
    }
}
