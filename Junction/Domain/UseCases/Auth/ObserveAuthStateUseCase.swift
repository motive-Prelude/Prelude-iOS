//
//  ObserveAuthStateUseCase.swift
//  Junction
//
//  Created by 송지혁 on 12/25/24.
//

import FirebaseAuth
import Foundation


class ObserveAuthStateUseCase {
    private let authRepository: AuthRepository
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
        
    func startObserving(onChange: @escaping (String?) -> Void) {
        authListenerHandle = authRepository.observeAuthState { userID in
            onChange(userID)
        }
    }
    
    func stopObserving() {
        if let handle = authListenerHandle {
            authRepository.removeAuthListener(handle)
            authListenerHandle = nil
        }
    }
    
}
