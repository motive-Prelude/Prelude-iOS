//
//  DIContainer.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Foundation
import CoreML

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    private init() {
        setupDependencies()
    }
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = String(reflecting: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(reflecting: type)
        return dependencies[key] as? T
    }
    
    private func setupDependencies() {
        register(APIClient.self, dependency: APIClient())
        register(FirebaseAuthDataSource.self, dependency: FirebaseAuthDataSource())
        register(SwiftDataSource.self, dependency: SwiftDataSource.shared)
        register(ICloudDataSource.self, dependency: ICloudDataSource.shared)
        register(FirestoreDataSource<UserInfo>.self, dependency: FirestoreDataSource<UserInfo>())
        
        // Repositories
        register(AuthRepository.self, dependency: FirebaseAuthRepository(dataSource: resolve(FirebaseAuthDataSource.self)!))
        register(ICloudUserRepository.self, dependency: ICloudUserRepository(iCloudDataSource: resolve(ICloudDataSource.self)!))
        register(FirestoreUserRepository.self, dependency: FirestoreUserRepository(dataSource: resolve(FirestoreDataSource<UserInfo>.self)!))
        register(FirebaseAuthRepository.self, dependency: FirebaseAuthRepository(dataSource: resolve(FirebaseAuthDataSource.self)!))
        register(SwiftDataUserRepository.self, dependency: SwiftDataUserRepository(dataSource: resolve(SwiftDataSource.self)!))

        register(UserSyncService.self, dependency: UserSyncService(remoteRepository: resolve(FirestoreUserRepository.self)!, cloudRepository: resolve(ICloudUserRepository.self)!, localRepository: resolve(SwiftDataUserRepository.self)!))
        
        register(LoginUseCase.self, dependency: LoginUseCase(authRepository: resolve(AuthRepository.self)!, userSyncService: resolve(UserSyncService.self)!))
        register(LogOutUseCase.self, dependency: LogOutUseCase(authRepository: resolve(AuthRepository.self)!))
        register(DeleteAccountUseCase.self, dependency: DeleteAccountUseCase(authRepository: resolve(AuthRepository.self)!, userSyncService: resolve(UserSyncService.self)!))
        register(ObserveAuthStateUseCase.self, dependency: ObserveAuthStateUseCase(authRepository: resolve(AuthRepository.self)!))
        register(ReauthenticateUseCase.self, dependency: ReauthenticateUseCase(authRepository: resolve(AuthRepository.self)!))
        
        register(AuthFacade.self, dependency: AuthFacade(loginUseCase: resolve(LoginUseCase.self)!,
                                                         logoutUseCase: resolve(LogOutUseCase.self)!,
                                                         reauthenticateUseCase: resolve(ReauthenticateUseCase.self)!,
                                                         deleteAccountUseCase: resolve(DeleteAccountUseCase.self)!,
                                                         observeAuthStateUseCase: resolve(ObserveAuthStateUseCase.self)!))
    }
}
