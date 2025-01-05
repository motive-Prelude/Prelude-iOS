//
//  AuthRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import FirebaseAuth
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let dataSource: FirebaseAuthDataSource
    
    init(dataSource: FirebaseAuthDataSource) {
        self.dataSource = dataSource
    }
    
    func logIn(parameter: AuthParameter) async throws(AuthError) -> String {
        guard let credential = getCredential(from: parameter) else { throw .invalidCredential }
        
        do {
            let userID = try await dataSource.logIn(credential: credential)
            return userID
        } catch { throw AuthError(from: error) }
    }
    
    func logOut() throws(AuthError) {
        do { try dataSource.logOut() }
        catch { throw AuthError(from: error) }
    }
    
    func deleteAccount(userID: String) async throws(AuthError) {
        do { try await dataSource.deleteAccount(userID: userID) }
        catch { throw AuthError(from: error) }
    }
    
    func reauthenticate(parameter: AuthParameter) async throws(AuthError) {
        guard let credential = getCredential(from: parameter) else { throw .invalidCredential }
        do { try await dataSource.reauthenticate(credential: credential) }
        catch { throw AuthError(from: error) }
    }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthStateDidChangeListenerHandle {
        return dataSource.observeAuthState(onChange: onChange)
    }
    
    func removeAuthListener(_ handle: AuthStateDidChangeListenerHandle) {
        return dataSource.removeAuthListener(handle)
    }
    
    private func getCredential(from parameter: AuthParameter) -> AuthCredential? {
        return AuthCredentialMapper.map(parameter: parameter)
    }
}
