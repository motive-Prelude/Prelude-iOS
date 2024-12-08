//
//  MessageRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

protocol MessageRepository {
    func createMessage(threadID: String, text: String, fileId: String) async throws -> CreateMessageResponse
    func retrieveMessage(threadID: String, messageID: String) async throws -> RetrieveMessageResponse
}
