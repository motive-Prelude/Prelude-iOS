//
//  ChatRepository.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import UIKit

protocol ChatRepository {
    func fetch(image: UIImage?, messages: [String], domainFilter: [String]?) async throws(DomainError) -> ChatAnswer
}
