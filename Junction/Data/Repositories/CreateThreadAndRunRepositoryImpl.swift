//
//  CreateThreadAndRunRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

final class CreateThreadAndRunRepositoryImpl: CreateThreadAndRunRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createThreadAndRun(assistantID: String, messages: [String], fileID: String) async throws -> ThreadAndRunResponse {
        guard let url = URL(string: EndPoint.threadsAndRun.urlString) else { throw URLError(.badURL) }
        let body = apiService.makeThreadAndRunBody(assistantID: assistantID, role: "user", messages: messages, fileID: fileID)
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        
        let result: ThreadAndRunResponse = try await apiService.fetchData(with: request)
        
        return result
    }
}
