//
//  FirebaseAuthListenerHandle.swift
//  Prelude
//
//  Created by 송지혁 on 4/11/25.
//

import FirebaseAuth

final class FirebaseAuthListenerHandle: AuthListenerHandle {
    private let handle: AuthStateDidChangeListenerHandle
    private let auth: Auth
    
    init(handle: AuthStateDidChangeListenerHandle, auth: Auth) {
        self.handle = handle
        self.auth = auth
    }
    
    func remove() {
        auth.removeStateDidChangeListener(handle)
    }
}
