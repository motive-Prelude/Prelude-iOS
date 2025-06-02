//
//  AuthRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import FirebaseAuth
import Foundation

final class FirebaseAuthRepository: AuthRepository {
    private let dataSource: FirebaseAuthDataSource
    
    init(dataSource: FirebaseAuthDataSource) {
        self.dataSource = dataSource
    }
    
    func logIn(parameter: AuthParameter) async throws(RepositoryError) -> (userID: String, sub: String) {
        let credential = parameter.toFirebaseCredential()
        guard let sub = parameter.hashedSub() else { throw .invalidCredential }
        
        do {
            let userID = try await dataSource.logIn(credential: credential)
            return (userID, sub)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func logOut() throws(RepositoryError) {
        do { try dataSource.logOut() }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func deleteAccount(id: String) async throws(RepositoryError) {
        do { try await dataSource.deleteAccount(userID: id) }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func reauthenticate(parameter: AuthParameter) async throws(RepositoryError) -> String {
        let credential = parameter.toFirebaseCredential()
        guard let sub = parameter.hashedSub() else { throw .invalidCredential }
        
        do {
            try await dataSource.reauthenticate(credential: credential)
            return sub
        }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthListenerHandle {
        return dataSource.observeAuthState(onChange: onChange)
    }
    
    func removeAuthListener(_ handle: AuthListenerHandle) {
        return dataSource.removeAuthListener(handle)
    }
}
