//
//  ThreadRepository.swift
//  bottari
//
//  Created by 송지혁 on 7/22/24.
//

import Combine

protocol ThreadRepository {
    func createThread(messages: [String]) -> AnyPublisher<ThreadResponse, Error>
}
