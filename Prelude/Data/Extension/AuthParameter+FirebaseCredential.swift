
import FirebaseAuth

extension AuthParameter {
    func toFirebaseCredential() -> AuthCredential {
        switch self {
            case let .apple(idToken, rawNonce, fullName):
                let apple = Apple(idToken: idToken, rawNonce: rawNonce, fullName: fullName)
                
                return OAuthProvider.appleCredential(withIDToken: apple.idToken,
                                                     rawNonce: apple.rawNonce,
                                                     fullName: apple.fullName)
                
        }
    }
    
    func hashedSub() -> String? {
        switch self {
            case let .apple(idToken, rawNonce, fullName):
                let apple = Apple(idToken: idToken, rawNonce: rawNonce, fullName: fullName)
                return apple.hashedSub()
        }
    }
}
