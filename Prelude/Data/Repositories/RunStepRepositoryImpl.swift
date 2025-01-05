//
//  RunStepRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Foundation

final class RunStepRepositoryImpl: RunStepRepository {
    private let apiService: APIClient
    
    init(apiService: APIClient) {
        self.apiService = apiService
    }
    
    func listRunSteps(threadID: String, runID: String) async throws(DomainError) -> RunStepResponse {
        guard let url = URL(string: EndPoint.runStep(threadID: threadID, runID: runID).urlString) else { throw .unknown }
        let request = apiService.makeURLRequest(to: url, method: .GET)
        
        do {
            let result: RunStepResponse = try await apiService.fetchData(with: request)
            return result
        } catch { throw ErrorMapper.map(error) }
    }

    
}
