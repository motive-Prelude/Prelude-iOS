//
//  ThreadRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

final class ThreadRepositoryImpl: ThreadRepository {
    private let apiService: APIClient
    
    init(apiService: APIClient) {
        self.apiService = apiService
    }
    
    func createThread(messages: [String], fileId: String) async throws(DomainError) -> ThreadResponse {
        let body = apiService.makeThreadBody(role: "user", messages: messages, fileId: fileId)
        guard let url = URL(string: EndPoint.threads.urlString) else { throw .unknown }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        do {
            let result: ThreadResponse = try await apiService.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
    }
}
