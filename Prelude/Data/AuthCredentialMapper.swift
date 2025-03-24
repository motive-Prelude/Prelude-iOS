//
//  AuthCredentialMapper.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import FirebaseAuth
import Foundation

struct AuthCredentialMapper {
    private init() { }
    
    static func map(parameter: AuthParameter) -> AuthCredential? {
        if let appleParameter = parameter as? AppleAuthCredentialParameter {
            
            return OAuthProvider.appleCredential(withIDToken: appleParameter.idToken,
                                                 rawNonce: appleParameter.rawNonce,
                                                 fullName: appleParameter.fullName)
        }
        
        return nil
    }
}
