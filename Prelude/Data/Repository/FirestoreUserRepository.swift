//
//  FirestoreUserRepository.swift
//  Prelude
//
//  Created by 송지혁 on 4/6/25.
//

import Foundation
import FirebaseFirestore

extension Array where Element == UserUpdateField {
    func toFirestoreFields() throws -> [String: Any] {
        var result = [String: Any]()
        
        for field in self {
            switch field {
                case .remainingTimes(let value):
                    result["remainingTimes"] = value
                
                case .incrementRemainingTimes(let value):
                    result["remainingTimes"] = FieldValue.increment(Int64(value))
                    
                case .healthInfo(let info):
                    let encoded = try Firestore.Encoder().encode(info)
                    result["healthInfo"] = encoded
                    
                case .termsAndConditions:
                    result["termsAccepted"] = true
                    result["termsAcceptedAt"] = Date()
                    
                case .markGiftAsReceived:
                    result["didReceiveGift"] = true
            }
        }
        return result
    }
}

enum UserCollection {
    case active
    case deleted
    
    var name: String {
        switch self {
            case .active: "User"
            case .deleted: "Deleted User"
        }
    }
}

final class FirestoreUserRepository: RemoteUserRepository {
    private let dataSource: FirestoreDataSource<UserInfo>
    
    init(dataSource: FirestoreDataSource<UserInfo>) {
        self.dataSource = dataSource
    }
    
    func save(_ user: UserInfo, in collection: UserCollection) async throws(RepositoryError) {
        do {
            try await dataSource.create(collection: collection.name, data: user)
        } catch {
            throw ErrorMapper.mapToRepository(error)
        }
    }
    
    func fetch(id: String, from collection: UserCollection) async throws(RepositoryError) -> UserInfo {
        do {
            let userInfo = try await dataSource.fetch(collection: collection.name, documentID: id)
            
            return userInfo
        } catch {
            throw ErrorMapper.mapToRepository(error)
        }
    }
    
    func update(id: String, fields: [UserUpdateField], in collection: UserCollection = .active) async throws(RepositoryError) -> UserInfo {
        do {
            var partialFields = try fields.toFirestoreFields()
            partialFields["lastModified"] = Date()
            
            try await dataSource.update(collection: collection.name, documentID: id, fields: partialFields)
            let userInfo = try await dataSource.fetch(collection: collection.name, documentID: id)
            
            return userInfo
        } catch let error as DataSourceError {
            throw ErrorMapper.mapToRepository(error)
        } catch { throw .dataParsingError }
    }
    
    func delete(id: String, from collection: UserCollection) async throws(RepositoryError) {
        do {
            try await dataSource.delete(collection: collection.name, documentID: id)
        } catch {
            throw ErrorMapper.mapToRepository(error)
        }
    }
}
