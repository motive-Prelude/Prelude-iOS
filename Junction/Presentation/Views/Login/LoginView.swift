//
//  LoginView.swift
//  Junction
//
//  Created by 송지혁 on 12/7/24.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        VStack {
            Text("아이디: \(userSession.userInfo?.id ?? "뭐야")")
                .bold()
            
            Text("남은 횟수: \(userSession.userInfo?.remainingTimes ?? 99999)")
            
            SignInWithAppleButton { request in
                loginViewModel.prepareAppleLogin(request: request)
            } onCompletion: { result in
                loginViewModel.makeAppleLoginCredential(result: result) { parameter in
                    Task { await userSession.login(parameter: parameter) }
                }
            }
            .frame(height: 60)
            
            Button("로그아웃") { userSession.logout() }
            Button("씨앗 추가") { Task { try await userSession.incrementSeeds(1) } }
        }
    }
}
