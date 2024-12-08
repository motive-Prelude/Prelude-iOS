//
//  LoginView.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import AuthenticationServices
import CryptoKit
import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel(loginUseCase: LoginUseCase(authRepository: AuthRepositoryImpl(authService: FirebaseAuthService())))
    
    var body: some View {
        SignInWithAppleButton { request in
            loginViewModel.prepareAppleLogin(request: request)
        } onCompletion: { result in
            loginViewModel.handleAppleLoginCompletion(result: result)
        }

    }
}

#Preview {
    LoginView()
}
