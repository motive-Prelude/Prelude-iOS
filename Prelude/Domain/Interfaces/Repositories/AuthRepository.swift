//
//  AuthRepository.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func logIn(parameter: AuthParameter) async throws(AuthError) -> String
    func logOut() throws(AuthError)
    func deleteAccount(userID: String) async throws(AuthError)
    func reauthenticate(parameter: AuthParameter) async throws(AuthError)
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthStateDidChangeListenerHandle
    func removeAuthListener(_ handle: AuthStateDidChangeListenerHandle)
}
