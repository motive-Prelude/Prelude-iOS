//
//  MessageRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine


protocol MessageRepository {
    func createMessage(threadID: String, text: String?, fileId: String?) -> AnyPublisher<CreateMessageResponse, Error>
    func retrieveMessage(threadID: String, messageID: String) -> AnyPublisher<RetrieveMessageResponse, Error>
}
