//
//  AppleReauthHelper.swift
//  Junction
//
//  Created by 송지혁 on 1/4/25.
//


import AuthenticationServices

protocol AuthHelper {
    associatedtype Parameter: AuthParameter
    func performAuth() async throws -> Parameter
}

final class AppleAuthHelper: NSObject, AuthHelper {
    private var continuation: CheckedContinuation<AppleAuthCredentialParameter, Error>?
    
    func performAuth() async throws -> AppleAuthCredentialParameter {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let nonce = CryptoUtils.randomNonceString()
            request.nonce = CryptoUtils.sha256(nonce)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleAuthHelper: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController, 
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityTokenData = appleIDCredential.identityToken,
            let identityToken = String(data: identityTokenData, encoding: .utf8),
            let nonce = CryptoUtils.getNonce() 
        else {
            continuation?.resume(throwing: AuthError.invalidCredential)
            continuation = nil
            return
        }

        let param = AppleAuthCredentialParameter(
            idToken: identityToken,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        continuation?.resume(returning: param)
        continuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleAuthHelper: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
