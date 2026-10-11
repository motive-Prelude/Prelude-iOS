//
//  AuthRepository.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation

protocol AuthRepository {
    func logIn(parameter: AuthParameter) async throws(RepositoryError) -> (userID: String, sub: String)
    func logOut() throws(RepositoryError)
    func deleteAccount(id: String) async throws(RepositoryError)
    func reauthenticate(parameter: AuthParameter) async throws(RepositoryError) -> String
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthListenerHandle
    func removeAuthListener(_ handle: AuthListenerHandle)
}
