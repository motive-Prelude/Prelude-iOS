//
//  FirebaseAuthService.swift
//  Junction
//
//  Created by 송지혁 on 12/6/24.
//

import FirebaseAuth

final class FirebaseAuthService {
    let auth = Auth.auth()
    
    func logIn(credential: AuthCredential) async throws {
        do {
            let result = try await auth.signIn(with: credential)
            let user = result.user
        } catch {
            print(error)
        }
    }
}
