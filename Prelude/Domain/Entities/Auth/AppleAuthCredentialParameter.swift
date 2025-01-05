//
//  AppleAuthCredentialParameter.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation

struct AppleAuthCredentialParameter: AuthParameter {
    let idToken: String
    let rawNonce: String
    let fullName: PersonNameComponents?
}
