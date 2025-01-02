//
//  AuthRepository.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func logIn(parameters: AuthParameter) async throws -> String
    func logout() throws
    func deleteAccount(userID: String)
    func reauthenticateWithApple() async throws
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthStateDidChangeListenerHandle
    func removeAuthListener(_ handle: AuthStateDidChangeListenerHandle)
}
