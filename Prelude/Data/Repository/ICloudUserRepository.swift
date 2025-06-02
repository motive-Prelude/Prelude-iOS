//
//  ICloudUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/7/25.
//

import Combine
import CloudKit

final class ICloudUserRepository: CloudUserRepository {
    private let dataSource: ICloudDataSource
    
    private var cancellables = Set<AnyCancellable>()
    let cloudChangeSubject = PassthroughSubject<String, Never>()
    
    init(iCloudDataSource: ICloudDataSource) {
        self.dataSource = iCloudDataSource
        
        observeCloudChanges()
    }
    
    func save(_ user: UserInfo) async throws(RepositoryError) {
        do {
            try await dataSource.save(user)
        } catch .conflict(let id) {
            try await mergeAndSave(user, id: id)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func fetch(id: String) async throws(RepositoryError) -> UserInfo {
        do {
            guard let userInfo: UserInfo = try await dataSource.fetch(id: id) else { throw RepositoryError.cloudDataNotFound }
            return userInfo
        } catch let error as DataSourceError {
            throw ErrorMapper.mapToRepository(error)
        } catch { throw RepositoryError.unknownError }
    }
    
    func delete(id: String) async throws(RepositoryError) {
        do {
            try await dataSource.delete(id: id)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func sync(id: String) async throws(RepositoryError) -> UserInfo {
        do {
            let record = try await dataSource.fetch(id: id)
            guard let userInfo = UserInfo(from: record) else { throw RepositoryError.dataParsingError }
            
            return userInfo
        } catch let error as RepositoryError { throw error }
        catch let error as DataSourceError { throw ErrorMapper.mapToRepository(error) }
        catch { throw .unknownError }
    }
    
    private func mergeAndSave(_ user: UserInfo, id: String) async throws(RepositoryError) {
        do {
            let record = try await dataSource.fetch(id: id)
            let mergedRecord = try merge(user, conflictRecord: record)
            try await dataSource.save(mergedRecord)
        } catch let error as DataSourceError { throw ErrorMapper.mapToRepository(error) }
        catch let error as RepositoryError { throw error }
        catch { throw .unknownError }
    }
    
    private func merge(_ local: UserInfo, conflictRecord: CKRecord) throws(RepositoryError) -> CKRecord {
        guard let iCloudDate = conflictRecord["lastModified"] as? Date else { throw RepositoryError.unknownError }
        
        if local.lastModified > iCloudDate {
            conflictRecord["remainingTimes"] = local.remainingTimes
            conflictRecord["lastModified"] = local.lastModified
            conflictRecord["didAgreeToTermsAndConditions"] = local.didAgreeToTermsAndConditions
            conflictRecord["didReceiveGift"] = local.didReceiveGift
            
            if let healthInfo = local.healthInfo {
                do {
                    let jsonData = try JSONEncoder().encode(healthInfo)
                    conflictRecord["healthInfo"] = jsonData as CKRecordValue
                } catch { throw RepositoryError.unknownError }
            }
        }
        
        return conflictRecord
    }
    
    private func observeCloudChanges() {
        dataSource.cloudKitNotificationSubject
            .sink { [weak self] id in
                guard let self = self else { return }
                self.cloudChangeSubject.send(id)
            }
            .store(in: &cancellables)
    }
    
}
