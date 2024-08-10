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
    
    func createRun(threadID: String, assistantID: String) -> AnyPublisher<RunResponse, Error> {
        let body = apiService.createRunBody(assistantID: assistantID)
        
        guard let request = apiService.createRequest(withURL: EndPoint.runs(threadID: threadID).urlString, body: body) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        return apiService.fetchData(with: request)
    }
    
}
