//
//  LoginViewModel.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import AuthenticationServices
import Foundation

class LoginViewModel: ObservableObject {    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func prepareAppleLogin(request: ASAuthorizationAppleIDRequest) {
        let nonce = CryptoUtils.randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtils.sha256(nonce)
    }
    
    func handleAppleLoginCompletion(result: Result<ASAuthorization, Error>)  {
        guard case .success(let authResult) = result, let appleIDCredential = authResult.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let idToken = appleIDCredential.identityToken else { return }
        guard let idTokenString = String(data: idToken, encoding: .utf8) else { return }
        let fullName = appleIDCredential.fullName
    
        Task {
            do {
                guard let nonce = CryptoUtils.getNonce() else { return }
                let parameters = AppleAuthCredentialParameter(idToken: idTokenString, rawNonce: nonce, fullName: fullName)
                try await loginUseCase.execute(parameter: parameters)
            } catch { print(error) }
        }
    }
    
    
    
    
}
