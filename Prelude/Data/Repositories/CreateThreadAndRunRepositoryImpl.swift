//
//  CreateThreadAndRunRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

final class CreateThreadAndRunRepositoryImpl: CreateThreadAndRunRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func createThreadAndRun(assistantID: String, messages: [String], fileID: String) async throws(DomainError) -> ThreadAndRunResponse {
        guard let url = URL(string: OpenAIEndPoint.threadsAndRun.urlString) else { throw .unknown }
        let body = apiClient.makeThreadAndRunBody(assistantID: assistantID, role: "user", messages: messages, fileID: fileID)
        let request = apiClient.makeURLRequest(to: url, body: .json(body))
        
        do {
            let result: ThreadAndRunResponse = try await apiClient.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
        
        
    }
}
