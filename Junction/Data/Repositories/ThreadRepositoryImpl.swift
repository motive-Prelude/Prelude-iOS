//
//  ThreadRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

final class ThreadRepositoryImpl: ThreadRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createThread(messages: [String], fileId: String) async throws -> ThreadResponse {
        let body = apiService.makeThreadBody(role: "user", messages: messages, fileId: fileId)
        guard let url = URL(string: EndPoint.threads.urlString) else { throw URLError(.badURL) }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        let result: ThreadResponse = try await apiService.fetchData(with: request)
        return result
    }
}
