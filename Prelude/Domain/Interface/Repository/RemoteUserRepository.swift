//
//  RemoteUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/5/25.
//

import Foundation

protocol RemoteUserRepository {
    func save(_ user: UserInfo, in collection: UserCollection) async throws(RepositoryError)
    func fetch(id: String , from collection: UserCollection) async throws(RepositoryError) -> UserInfo
    func update(id: String, fields: [UserUpdateField], in collection: UserCollection) async throws(RepositoryError) -> UserInfo
    func delete(id: String, from collection: UserCollection) async throws(RepositoryError)
    
}
