//
//  RunStepRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine
import Foundation

protocol RunStepRepository {
    func listRunSteps(threadID: String, runID: String) async throws -> RunStepResponse
}
