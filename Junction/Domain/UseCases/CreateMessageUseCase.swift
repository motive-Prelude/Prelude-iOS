//
//  CreateMessageUseCase.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

final class CreateMessageUseCase {
    private let repository: MessageRepository
    
    init(repository: MessageRepository) {
        self.repository = repository
    }
    
    func execute(threadID: String, text: String?, fileId: String?) -> AnyPublisher<CreateMessageResponse, Error> {
        return repository.createMessage(threadID: threadID, text: text, fileId: fileId)
    }
}
