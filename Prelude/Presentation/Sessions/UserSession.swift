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
    private let userRepository: UserRepository
    private let loginUseCase: LoginUseCase
    private let logoutUseCase: LogOutUseCase
    private let reauthenticateUseCase: ReauthenticateUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository,
         loginUseCase: LoginUseCase,
         logOutUseCase: LogOutUseCase,
         reauthenticateUseCase: ReauthenticateUseCase,
         deleteAccountUseCase: DeleteAccountUseCase,
         observeAuthStateUseCase: ObserveAuthStateUseCase) {
        self.userRepository = userRepository
        self.loginUseCase = loginUseCase
        self.logoutUseCase = logOutUseCase
        self.reauthenticateUseCase = reauthenticateUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.observeAuthStateUseCase = observeAuthStateUseCase
        observeRepositoryChanges()
        observeAuthState()
    }
    
    var hasReceiveGift: Bool {
        guard let userInfo else { return true }
        return userInfo.didReceiveGift
    }
    
    func login(parameter: AuthParameter) async {
        do {
            let userID = try await loginUseCase.execute(parameter: parameter)
            let userInfo = try await userRepository.fetch(userID: userID)
            
            await MainActor.run {
                self.isAuthenticated = true
                self.userInfo = userInfo
            }
            
        } catch { EventBus.shared.errorPublisher.send(error) }
    }
    
    func logout(completion: @escaping () -> ()) {
        do {
            try logoutUseCase.execute()
            
            self.userInfo = nil
            isAuthenticated = false
            completion()
        } catch { EventBus.shared.errorPublisher.send(error) }
    }
    
    func reauthenticate(_ loginProvider: LoginProvider) async -> Bool {
        let helper = getAuthHelper(loginProvider)
        do {
            let parameter = try await helper.performAuth()
            try await reauthenticateUseCase.execute(parameter: parameter)
        } catch let error as DomainError {
            EventBus.shared.errorPublisher.send(error)
            return false
        }
        catch {
            print(#function, error)
            EventBus.shared.errorPublisher.send(DomainError.authenticationFailed(reason: "인증 실패"))
            return false
        }
        
        return true
    }
    
    func getAuthHelper(_ loginProvider: LoginProvider) -> any AuthHelper {
        switch loginProvider {
            case .apple: return AppleAuthHelper()
        }
    }
    
    func deleteAccount(completion: @escaping () -> ()) async {
        guard let userID = userInfo?.id else { return }
        do {
            try await deleteAccountUseCase.execute(userID: userID)
            try await userRepository.delete(userID: userID)
        } catch {
            EventBus.shared.errorPublisher.send(error)
            return
        }
        
        
        await MainActor.run {
            self.userInfo = nil
            self.isAuthenticated = false
            completion()
        }
    }
    
    func update(healthInfo: HealthInfo) {
        guard let userInfo else { return }
        userInfo.healthInfo = healthInfo
        do {
            let healthInfoDict = try Firestore.Encoder().encode(healthInfo)
            Task { try await userRepository.update(userID: userInfo.id, field: ["healthInfo": healthInfoDict]) }
        } catch let error as DomainError { EventBus.shared.errorPublisher.send(error) }
        catch { }
    }
    
    func updateCurrentUser() async -> Bool {
        guard let userInfo else { return false }
        do {
            try await userRepository.update(user: userInfo)
            return true
        } catch { EventBus.shared.errorPublisher.send(error) }
        
        return false
    }
    
    func syncCurrentUserFromServer() async throws(DomainError) -> UserInfo? {
        guard let userID = userInfo?.id else { return nil }
        do {
            let newUserInfo = try await userRepository.fetch(userID: userID)
            await MainActor.run { self.userInfo = newUserInfo }
            return newUserInfo
            
        } catch { EventBus.shared.errorPublisher.send(error) }
        
        return nil
    }
    
    @MainActor
    func incrementSeeds(_ count: Int) async throws(DomainError) {
        if count < 0 { assertionFailure("incrementSeeds 메서드에 음수가 들어갔어요.") }
        
        guard let userInfo = userInfo else { return }
        do {
            self.userInfo = try await userRepository.update(userID: userInfo.id, field: ["remainingTimes": FieldValue.increment(Int64(count))])
        } catch { EventBus.shared.errorPublisher.send(error) }
    }
    
    @MainActor
    func decrementSeeds(_ count: Int) async throws(DomainError) {
        if count < 0 { assertionFailure("incrementSeeds 메서드에 음수가 들어갔어요.") }
        
        guard let userInfo = userInfo else { return }
        do {
            self.userInfo = try await userRepository.update(userID: userInfo.id, field: ["remainingTimes": FieldValue.increment(Int64(-count))])
        } catch { EventBus.shared.errorPublisher.send(error) }
    }
    
    private func observeRepositoryChanges() {
        userRepository.iCloudChangeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let userInfo else { return }
                Task {
                    let newUserInfo = try await self.userRepository.syncFromICloud(userID: userInfo.id)
                    await MainActor.run { self.userInfo = newUserInfo }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeAuthState() {
        observeAuthStateUseCase.startObserving { [weak self] userID in
            guard let self = self else { return }
            if let userID = userID {
                Task {
                    do {
                        let userInfo = try await self.userRepository.fetch(userID: userID)
                        await MainActor.run {
                            self.userInfo = userInfo
                            self.isAuthenticated = true
                        }
                    } catch { print("UserInfo fetch 실패: \(error)") }
                }
            } else {
                self.userInfo = nil
                isAuthenticated = false
            }
        }
    }
}
