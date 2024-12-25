//
//  AuthRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import FirebaseAuth
import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let authService: FirebaseAuthService
    
    init(authService: FirebaseAuthService) {
        self.authService = authService
    }
    
    func logIn(parameters: AuthParameter) async throws -> String {
        guard let credential = AuthCredentialMapper.map(parameter: parameters) else { return "" }
        let user = try await authService.logIn(credential: credential)
        return user.uid
    }
    
    func logout() throws { try authService.logOut() }
    
    func deleteAccount(userID: String) { authService.deleteAccount(userID: userID) }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthStateDidChangeListenerHandle {
        return authService.observeAuthState(onChange: onChange)
    }
    
    func removeAuthListener(_ handle: AuthStateDidChangeListenerHandle) {
        authService.removeAuthListener(handle)
    }
}
