//
//  SwiftDataUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/10/25.
//

final class SwiftDataUserRepository: LocalUserRepository {
    private let dataSource: SwiftDataSource
    
    init(dataSource: SwiftDataSource) {
        self.dataSource = dataSource
    }
    
    func save(_ user: UserInfo) async throws(RepositoryError) {
        do {
            try dataSource.saveData(user)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func fetch() async throws(RepositoryError) -> UserInfo {
        do {
            let userInfo = try dataSource.fetchLatest(data: UserInfo.self)
            return userInfo
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func delete(_ data: UserInfo) async throws(RepositoryError) {
        do {
            try dataSource.delete(data: data)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func deleteAll(_ data: UserInfo) async throws(RepositoryError) {
        do {
            try dataSource.removeAll(type: UserInfo.self)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
}
