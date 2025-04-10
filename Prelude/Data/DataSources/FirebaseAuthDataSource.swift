//
//  FirebaseAuthService.swift
//  Junction
//
//  Created by 송지혁 on 12/6/24.
//

import FirebaseAuth

final class FirebaseAuthDataSource {
    private let auth = Auth.auth()
    
    func logIn(credential: AuthCredential) async throws(AuthError) -> String {
        do {
            let result = try await auth.signIn(with: credential)
            let user = result.user
            
            return user.uid
        } catch let error as AuthErrorCode { throw mapFirebaseErrorToAuthError(error) }
        catch { throw .unknown }
    }
    
    func logOut() throws(AuthError) {
        do {
            try auth.signOut()
        } catch let error as AuthErrorCode { throw mapFirebaseErrorToAuthError(error) }
        catch { throw .unknown }
    }
    
    func deleteAccount(userID: String) async throws(AuthError) {
        guard let currentUser = auth.currentUser else { throw .userNotFound }
        guard userID == currentUser.uid else { throw .userMismatch }
        
        do { try await currentUser.delete() }
        catch let error as AuthErrorCode { throw mapFirebaseErrorToAuthError(error) }
        catch { throw .unknown }
    }
    
    func reauthenticate(credential: AuthCredential) async throws(AuthError) {
        guard let currentUser = auth.currentUser else { throw .userNotFound }
        do { try await currentUser.reauthenticate(with: credential) }
        catch let error as AuthErrorCode { throw mapFirebaseErrorToAuthError(error) }
        catch { throw .unknown }
    }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthListenerHandle {
        let handle = auth.addStateDidChangeListener { _, user in
            onChange(user?.uid)
        }
        return FirebaseAuthListenerHandle(handle: handle, auth: auth)
    }
    
    func removeAuthListener(_ handle: AuthListenerHandle) {
        handle.remove()
    }
        
    private func mapFirebaseErrorToAuthError(_ error: AuthErrorCode) -> AuthError {
        switch error {
            case .accountExistsWithDifferentCredential: return .invalidCredential
            case .credentialAlreadyInUse: return .invalidCredential
            case .invalidCredential: return .invalidCredential
            case .networkError: return .networkError
            case .tooManyRequests: return .tooManyRequests
            case .sessionExpired: return .sessionExpired
            case .userDisabled: return .userDisabled
            case .userNotFound: return .userNotFound
            case .userMismatch: return .userMismatch
            default: return .unknown
        }
    }
}
