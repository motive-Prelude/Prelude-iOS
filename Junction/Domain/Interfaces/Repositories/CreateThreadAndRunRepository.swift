//
//  CreateThreadAndRunRepository.swift
//  Junction
//
//  Created by 송지혁 on 10/31/24.
//

import Foundation

protocol CreateThreadAndRunRepository {
    func createThreadAndRun(assistantID: String, messages: [String], fileID: String) async throws -> ThreadAndRunResponse
}
