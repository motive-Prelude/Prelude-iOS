//
//  FirebaseAuthService.swift
//  Junction
//
//  Created by 송지혁 on 12/6/24.
//

import FirebaseAuth

final class FirebaseAuthDataSource {
    let auth = Auth.auth()
    
    func logIn(credential: AuthCredential) async throws(AuthErrorCode) -> String {
        do {
            let result = try await auth.signIn(with: credential)
            let user = result.user
            
            return user.uid
        } catch let error as AuthErrorCode { throw error }
        catch { throw .appNotAuthorized }
    }
    
    func logOut() throws(AuthErrorCode) {
        do {
            try auth.signOut()
        } catch let error as AuthErrorCode { throw error }
        catch { throw .appNotAuthorized }
    }
    
    func deleteAccount(userID: String) async throws(AuthErrorCode) {
        guard let currentUser = auth.currentUser else { throw .userNotFound }
        guard userID == currentUser.uid else { throw .userMismatch }
        
        do { try await currentUser.delete() }
        catch let error as AuthErrorCode { throw error }
        catch { throw .appNotAuthorized }
    }
    
    func reauthenticate(credential: AuthCredential) async throws(AuthErrorCode) {
        guard let currentUser = auth.currentUser else { throw .userNotFound }
        do { try await currentUser.reauthenticate(with: credential) }
        catch let error as AuthErrorCode { throw error }
        catch { throw .appNotAuthorized }
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
