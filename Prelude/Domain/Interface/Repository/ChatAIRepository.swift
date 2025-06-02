//
//  ChatAIRepository.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//


protocol ChatAIRepository {
    func fetch<T: Decodable>(image: UIImage?, messages: [String], as type: T.Type) async throws(DomainError) -> (T, [Citation])
}