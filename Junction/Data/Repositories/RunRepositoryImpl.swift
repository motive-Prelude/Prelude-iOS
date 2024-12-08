//
//  RunRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

final class RunRepositoryImpl: RunRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createRun(threadID: String, assistantID: String) async throws -> RunResponse {
        let body = apiService.createRunBody(assistantID: assistantID)
        guard let url = URL(string: EndPoint.runs(threadID: threadID).urlString) else { throw URLError(.badURL) }
        let request = apiService.makeURLRequest(to: url, body: .json(body))
        let result: RunResponse = try await apiService.fetchData(with: request)
        
        return result
    }
    
}
