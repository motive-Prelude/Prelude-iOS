//
//  UserRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Combine
import CloudKit

class UserRepository {
    private let swiftDataSource: SwiftDataSource
    private let iCloudDataSource: ICloudDataSource
    private let firestoreDataSource: FirestoreDataSource<UserInfo>
    private var cancellables = Set<AnyCancellable>()
    let iCloudChangeSubject = PassthroughSubject<Void, Never>()
    
    
    init(swiftDataSource: SwiftDataSource = .shared,
         iCloudDataSource: ICloudDataSource = .shared,
         firestoreDataSource: FirestoreDataSource<UserInfo>) {
        self.swiftDataSource = swiftDataSource
        self.iCloudDataSource = iCloudDataSource
        self.firestoreDataSource = firestoreDataSource
        
        observeICloudChanges()
    }
    
    func create(user: UserInfo) async throws(DomainError) {
        do {
            try await firestoreDataSource.create(collection: "User", data: user)
            await saveToSecondaryDataSource(user: user)
        } catch { throw ErrorMapper.map(error) }
    }
    
    private func createNewUser(userID: String) async throws(DomainError) -> UserInfo {
        let newUserInfo = UserInfo(id: userID, remainingTimes: 0)
        
        do { try await create(user: newUserInfo) }
        catch { throw error }
        
        return newUserInfo
    }
    
    func fetch(userID: String) async throws(DomainError) -> UserInfo {
        do {
            let user = try await firestoreDataSource.fetch(collection: "User", documentID: userID)
            await saveToSecondaryDataSource(user: user)
            
            return user
        } catch .notFound { return try await createNewUser(userID: userID) }
        catch { throw .unknown }
    }
    
    func update(user: UserInfo) async throws(DomainError) {
        do {
            try await firestoreDataSource.update(collection: "User", data: user)
            await saveToSecondaryDataSource(user: user)
            
        } catch { throw ErrorMapper.map(error) }
    }
    
    func update(userID: String, field: [String: Any]) async throws(DomainError) -> UserInfo {
        do {
            try await firestoreDataSource.update(collection: "User", documentID: userID, fields: field)
            let newUserInfo = try await self.fetch(userID: userID)
            return newUserInfo
        } catch let error as DataSourceError { throw ErrorMapper.map(error) }
        catch let error as DomainError { throw error }
        catch { throw .unknown }
    }
    
    func delete(userID: String) async throws(DomainError) {
        do {
            try await firestoreDataSource.delete(collection: "User", documentID: userID)
            try swiftDataSource.removeAll()
        } catch { throw ErrorMapper.map(error) }
    }
    
    private func observeICloudChanges() {
        iCloudDataSource.cloudKitNotificationSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.iCloudChangeSubject.send()
            }
            .store(in: &cancellables)
    }
    
    func syncFromICloud(userID: String) async throws(DomainError) -> UserInfo {
        do {
            guard let record = try await iCloudDataSource.fetch(userID: userID) else { throw DomainError.unknown }
            guard let userInfo = UserInfo(from: record) else { throw DomainError.unknown }
            try swiftDataSource.saveData(userInfo)
            return userInfo
        } catch let error as DataSourceError { throw ErrorMapper.map(error) }
        catch { throw .unknown }
    }
    
    private func saveToSecondaryDataSource(user: UserInfo) async {
        if let _ = try? await iCloudDataSource.save(user: user) {
            print(#function, "iCloud save Success")
        }
        
        if let _ = try? swiftDataSource.saveData(user) {
            print(#function, "swiftData save Success")
        }
    }
}
