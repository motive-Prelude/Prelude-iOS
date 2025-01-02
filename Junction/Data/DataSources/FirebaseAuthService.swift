//
//  FirebaseAuthService.swift
//  Junction
//
//  Created by 송지혁 on 12/6/24.
//

import FirebaseAuth

final class FirebaseAuthService {
    let auth = Auth.auth()
    
    func logIn(credential: AuthCredential) async throws -> User {
        let result = try await auth.signIn(with: credential)
        let user = result.user
        
        return user
    }
    
    func logOut() throws { try auth.signOut() }
    
    func deleteAccount(userID: String) {
        guard let currentUser = auth.currentUser else { return }
        guard userID == currentUser.uid else { return }
        
        currentUser.delete()
    }
    
    func reauthenticate(credential: AuthCredential) {
        guard let currentUser = auth.currentUser else { return }
        currentUser.reauthenticate(with: credential)
    }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            onChange(user?.uid)
        }
    }
    
    func removeAuthListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }
}
