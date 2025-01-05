//
//  CryptoUtils.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import CryptoKit
import Foundation

struct CryptoUtils {
    private static var currentNonce: String?
    
    private init() { }
    
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess { fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)") }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { charset[Int($0) % charset.count] }
        currentNonce = String(nonce)
        return String(nonce)
    }
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.map { String(format: "%02x", $0) }.joined()
    }
    
    static func getNonce() -> String? {
        guard let nonce = currentNonce else { return nil }
        return nonce
    }
}
