//
//  AuthParameter.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation

enum AuthParameter: Equatable {
    case apple(idToken: String, rawNonce: String, fullName: PersonNameComponents?)
    
    struct Apple: Equatable {
        let idToken: String
        let rawNonce: String
        let fullName: PersonNameComponents?
    }
}
