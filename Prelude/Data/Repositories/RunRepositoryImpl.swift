//
//  RunRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

final class RunRepositoryImpl: RunRepository {
    private let apiService: APIClient
    
    init(apiService: APIClient) {
        self.apiService = apiService
    }
    
    func createRun(threadID: String, assistantID: String) async throws(DomainError) -> RunResponse {
        let body = apiService.createRunBody(assistantID: assistantID)
        guard let url = URL(string: OpenAIEndPoint.runs(threadID: threadID).urlString) else { throw .unknown }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        do {
            let result: RunResponse = try await apiService.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
    }
}
