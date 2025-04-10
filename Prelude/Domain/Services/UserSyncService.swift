//
//  UserSyncServices.swift
//  Prelude
//
//  Created by 송지혁 on 4/6/25.
//

import Combine
import Foundation

final class UserSyncService {
    private let remoteRepository: RemoteUserRepository
    private let cloudRepository: CloudUserRepository
    private let localRepository: LocalUserRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(remoteRepository: RemoteUserRepository, cloudRepository: CloudUserRepository, localRepository: LocalUserRepository) {
        self.remoteRepository = remoteRepository
        self.cloudRepository = cloudRepository
        self.localRepository = localRepository
        
        observeCloudChanges()
    }
    
    func save(user: UserInfo, in collection: UserCollection) async throws(DomainError) {
        do {
            try await remoteRepository.save(user, in: collection)
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
        
        async let cloud: ()? = try? cloudRepository.save(user)
        async let local: ()? = try? localRepository.save(user)
        
        _ = await (cloud, local)
    }
    
    func fetch(id: String, from collection: UserCollection) async throws(DomainError) -> UserInfo {
        if let cached = try? await localRepository.fetch() {
            Task {
                if let updated = try? await remoteRepository.fetch(id: id, from: collection) {
                    try? await cloudRepository.save(updated)
                    try? await localRepository.save(updated)
                }
            }
            
            return cached
        }
        
        do {
            let remote = try await remoteRepository.fetch(id: id, from: collection)
            
            async let cloud: ()? = try? await cloudRepository.save(remote)
            async let local: ()? = try? await localRepository.save(remote)
            
            _ = await (cloud, local)
            
            return remote
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
        
    }
    
    @discardableResult
    func update(id: String, fields: [UserUpdateField], in collection: UserCollection) async throws(DomainError) -> UserInfo {
        do {
            let updatedUser = try await remoteRepository.update(id: id, fields: fields, in: collection)
            
            async let cloud: ()? = try? cloudRepository.save(updatedUser)
            async let local: ()? = try? localRepository.save(updatedUser)
            
            _ = await (cloud, local)
            
            return updatedUser
        } catch { throw ErrorMapper.mapToDomain(error) }
    }
    
    func delete(id: String, from collection: UserCollection) async throws(DomainError) {
        do {
            let userInfo = try await remoteRepository.fetch(id: id, from: collection)
            try await remoteRepository.delete(id: id, from: collection)
            
            async let cloud: ()? = try? cloudRepository.delete(id: id)
            async let local: ()? = try? localRepository.deleteAll(userInfo)
            
            _ = await (cloud, local)
            
        } catch {
            throw ErrorMapper.mapToDomain(error)
        }
    }
    
    func checkRejoinUser(id: String, from collection: UserCollection = .deleted) async throws(DomainError) -> UserInfo? {
        do {
            let deletedUser = try await remoteRepository.fetch(id: id, from: collection)
            return deletedUser
        } catch { return nil }
    }
    
    private func observeCloudChanges() {
        cloudRepository.cloudChangeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self else { return }
                
                Task {
                    let newUserInfo = try await self.cloudRepository.sync(id: id)
                    try await self.localRepository.save(newUserInfo)
                }
            }
            .store(in: &cancellables)
    }
}
