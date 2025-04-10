//
//  CloudUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/5/25.
//

import Combine
import Foundation

protocol CloudUserRepository {
    var cloudChangeSubject: PassthroughSubject<String, Never> { get }
    
    func save(_ user: UserInfo) async throws(RepositoryError)
    func fetch(id: String) async throws(RepositoryError) -> UserInfo
    func delete(id: String) async throws(RepositoryError)
    func sync(id: String) async throws(RepositoryError) -> UserInfo
    
    
}
