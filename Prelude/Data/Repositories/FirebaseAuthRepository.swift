//
//  AuthRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import FirebaseAuth
import Foundation

final class FirebaseAuthRepository: AuthRepository {
    private let dataSource: FirebaseAuthDataSource
    
    init(dataSource: FirebaseAuthDataSource) {
        self.dataSource = dataSource
    }
    
    func logIn(parameter: AuthParameter) async throws(RepositoryError) -> (userID: String, sub: String) {
        guard let credential = getCredential(from: parameter) else { throw .invalidCredential }
        guard let sub = decodeSub(from: parameter.idToken) else { throw .invalidCredential }
        
        do {
            let userID = try await dataSource.logIn(credential: credential)
            return (userID, sub)
        } catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func logOut() throws(RepositoryError) {
        do { try dataSource.logOut() }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func deleteAccount(id: String) async throws(RepositoryError) {
        do { try await dataSource.deleteAccount(userID: id) }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func reauthenticate(parameter: AuthParameter) async throws(RepositoryError) -> String {
        guard let credential = getCredential(from: parameter) else { throw .invalidCredential }
        guard let sub = decodeSub(from: parameter.idToken) else { throw .invalidCredential }
        do {
            try await dataSource.reauthenticate(credential: credential)
            return sub
        }
        catch { throw ErrorMapper.mapToRepository(error) }
    }
    
    func observeAuthState(onChange: @escaping (String?) -> Void) -> AuthListenerHandle {
        return dataSource.observeAuthState(onChange: onChange)
    }
    
    func removeAuthListener(_ handle: AuthListenerHandle) {
        return dataSource.removeAuthListener(handle)
    }
    
    private func getCredential(from parameter: AuthParameter) -> AuthCredential? {
        return AuthCredentialMapper.map(parameter: parameter)
    }
    
    private func decodeSub(from idToken: String) -> String? {
        let segments = idToken.components(separatedBy: ".")
        guard segments.count == 3 else { return nil }
        
        let payloadSegment = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        var padded = payloadSegment
        while padded.count % 4 != 0 {
            padded += "="
        }
        
        guard let payloadData = Data(base64Encoded: padded) else {
            return nil
        }
        
        struct AppleTokenPayload: Decodable {
            let sub: String
        }
        
        do {
            let payload = try JSONDecoder().decode(AppleTokenPayload.self, from: payloadData)
            let hashedSub = CryptoUtils.sha256(payload.sub)
            return hashedSub
        } catch {
            print("JWT 디코딩 에러: \(error)")
            return nil
        }
    }
}
