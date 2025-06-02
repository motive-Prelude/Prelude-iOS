//
//  AuthParameter+FirebaseCredential.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import Foundation

extension AuthParameter.Apple {
    func hashedSub() -> String? {
        let segments = idToken.split(separator: ".")
        guard segments.count == 3 else { return nil }
        
        var payload = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while payload.count % 4 != 0 { payload += "=" }
        guard let data = Data(base64Encoded: payload) else { return nil }
        
        struct Payload: Decodable { let sub: String }
        guard let sub = try? JSONDecoder().decode(Payload.self, from: data).sub else { return nil }
        return CryptoUtils.sha256(sub)
    }
}
