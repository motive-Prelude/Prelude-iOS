//
//  LocalUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/5/25.
//

protocol LocalUserRepository {
    func save(_ user: UserInfo) async throws(RepositoryError)
    func fetch() async throws(RepositoryError) -> UserInfo
    func delete(_ data: UserInfo) async throws(RepositoryError)
    func deleteAll(_ data: UserInfo) async throws(RepositoryError)
}
