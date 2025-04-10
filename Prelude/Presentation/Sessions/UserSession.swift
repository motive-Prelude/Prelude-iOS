//
//  UserStore.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Combine
import FirebaseFirestore
import Foundation

class UserSession: ObservableObject {
    @Published private(set) var userInfo: UserInfo?
    @Published private(set) var isAuthenticated = false
    
    private let userSyncService: UserSyncService
    private let authFacade: AuthFacade
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userSyncService: UserSyncService, authFacade: AuthFacade) {
        self.userSyncService = userSyncService
        self.authFacade = authFacade
        
        observeAuthState()
    }
    
    var hasReceiveGift: Bool {
        guard let userInfo else { return true }
        return userInfo.didReceiveGift
    }
    
    func login(parameter: AuthParameter) async throws(DomainError) {
        let userInfo = try await authFacade.login(parameter: parameter)
        await MainActor.run { applyAuthenticatedState(with: userInfo) }
    }
    
    @MainActor
    func logout(completion: @escaping () -> ()) throws(DomainError) {
        try authFacade.logout()
        applyUnauthenticatedState()
        completion()
    }
    
    func reauthenticate(_ loginProvider: LoginProvider) async throws(DomainError) -> String {
        return try await authFacade.reauthenticate(loginProvider)
    }
    
    func deleteAccount(sub: String, completion: @escaping () -> ()) async throws(DomainError) {
        guard let id = userInfo?.id else { throw .userNotFound }
        try await authFacade.deleteAccount(id: id, sub: sub)
        
        await MainActor.run {
            applyUnauthenticatedState()
            completion()
        }
        
    }
    
    func update(healthInfo: HealthInfo) async throws(DomainError) {
        guard let userInfo else { throw .userNotFound }
        let id = userInfo.id
        
        let updatedUserInfo = try await userSyncService.update(id: id, fields: [.healthInfo(healthInfo)], in: .active)
        
        await MainActor.run {
            self.userInfo = updatedUserInfo
        }
    }
    
    func updateCurrentUser() async throws(DomainError) -> Bool {
        guard let userInfo else { throw .userNotFound }
        try await userSyncService.save(user: userInfo, in: .active)
        return true
    }
    
    func syncCurrentUserFromServer() async throws(DomainError) -> UserInfo? {
        guard let id = userInfo?.id else { throw .userNotFound }
        let syncedUserInfo = try await userSyncService.fetch(id: id, from: .active)
        await MainActor.run { self.userInfo = syncedUserInfo }
        
        return syncedUserInfo
    }
    
    @MainActor
    func addGiftTokens(_ amount: Int) async throws(DomainError) {
        guard let userInfo else { throw .userNotFound }
        
        let id = userInfo.id
        self.userInfo = try await userSyncService.update(id: id, fields: [.remainingTimes(amount)], in: .active)
    }
    
    @MainActor
    func incrementSeeds(_ amount: Int) async throws(DomainError) {
        if amount < 0 { throw DomainError.invalidArgument }
        
        guard let userInfo = userInfo else { return }
        let id = userInfo.id
        self.userInfo = try await userSyncService.update(id: id, fields: [.incrementRemainingTimes(amount)], in: .active)
    }
    
    @MainActor
    func decrementSeeds(_ amount: Int) async throws(DomainError) {
        if amount < 0 { throw DomainError.invalidArgument }
        
        guard let userInfo = userInfo else { return }
        let id = userInfo.id
        self.userInfo = try await userSyncService.update(id: id, fields: [.incrementRemainingTimes(-amount)], in: .active)
    }
    
    private func observeAuthState() {
        authFacade.observeAuthState() { [weak self] id in
            guard let self else { return }
            guard let id else {
                self.applyUnauthenticatedState()
                return
            }
            
            Task {
                do {
                    let userInfo = try await self.userSyncService.fetch(id: id, from: .active)
                    await MainActor.run { self.applyAuthenticatedState(with: userInfo) }
                } catch { print("UserInfo fetch 실패: \(error)") }
            }
        }
    }
    
    private func applyAuthenticatedState(with userInfo: UserInfo) {
        self.userInfo = userInfo
        self.isAuthenticated = true
    }
    
    private func applyUnauthenticatedState() {
        self.userInfo = nil
        self.isAuthenticated = false
    }
}
