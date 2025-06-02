//
//  AuthService.swift
//  Prelude
//
//  Created by 송지혁 on 4/9/25.
//

import Foundation

final class AuthFacade {
    private let loginUseCase: LoginUseCase
    private let logoutUseCase: LogOutUseCase
    private let reauthenticateUseCase: ReauthenticateUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    
    init(loginUseCase: LoginUseCase, logoutUseCase: LogOutUseCase, reauthenticateUseCase: ReauthenticateUseCase, deleteAccountUseCase: DeleteAccountUseCase, observeAuthStateUseCase: ObserveAuthStateUseCase) {
        self.loginUseCase = loginUseCase
        self.logoutUseCase = logoutUseCase
        self.reauthenticateUseCase = reauthenticateUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.observeAuthStateUseCase = observeAuthStateUseCase
    }
    
    func login(_ provider: LoginProvider) async throws(DomainError) -> UserInfo {
        do {
            let authHelper = getAuthHelper(provider)
            let parameter = try await authHelper.performAuth()
            let userInfo = try await loginUseCase.execute(parameter: parameter)
            
            return userInfo
        } catch let error as DomainError { throw error }
        catch { throw .authenticationFailed }

    }
    
    func logout() throws(DomainError) {
        try logoutUseCase.execute()
    }
    
    func reauthenticate(_ loginProvider: LoginProvider) async throws(DomainError) -> String {
        do {
            let authHelper = getAuthHelper(loginProvider)
            let parameter = try await authHelper.performAuth()
            
            return try await reauthenticateUseCase.execute(parameter: parameter)
        } catch let error as DomainError { throw error }
        catch { throw .authenticationFailed }
    }
    
    private func getAuthHelper(_ loginProvider: LoginProvider) -> any AuthHelper {
        switch loginProvider {
            case .apple: return AppleAuthHelper()
        }
    }
    
    func deleteAccount(id: String, sub: String) async throws(DomainError) {
        try await deleteAccountUseCase.execute(id: id, sub: sub)
    }
    
    func observeAuthState(onChange: @escaping (_ id: String?) -> ()) {
        observeAuthStateUseCase.startObserving { id in
            onChange(id)
        }
    }
    
    
}
