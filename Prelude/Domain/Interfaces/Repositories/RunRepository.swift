//
//  RunRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

protocol RunRepository {
    func createRun(threadID: String, assistantID: String) async throws -> RunResponse
}
