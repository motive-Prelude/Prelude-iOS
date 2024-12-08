//
//  ThreadRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

protocol ThreadRepository {
    func createThread(messages: [String], fileId: String) async throws -> ThreadResponse
}
