//
//  RunStepRepositoryImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

final class RunStepRepositoryImpl: RunStepRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func listRunSteps(threadID: String, runID: String) -> AnyPublisher<RunStepResponse, Error> {
        guard let request = apiService.createRequest(withURL: EndPoint.runStep(threadID: threadID, runID: runID).urlString, method: "GET", body: nil as String?) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return apiService.fetchData(with: request)
    }

    
}
