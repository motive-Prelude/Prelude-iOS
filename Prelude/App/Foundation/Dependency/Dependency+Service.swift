//
//  Dependency+Service.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture

private enum UserSyncServiceKey: DependencyKey {
    static let liveValue: UserSyncService = {
        @Dependency(\.firestoreUserRepository) var firestoreUserRepository
        @Dependency(\.iCloudUserRepository) var iCloudUserRepository
        @Dependency(\.swiftDataUserRepository) var swiftDataUserRepository
        
        return UserSyncService(remoteRepository: firestoreUserRepository,
                               cloudRepository: iCloudUserRepository,
                               localRepository: swiftDataUserRepository)
        
    }()
}

private enum AuthFacadeKey: DependencyKey {
    static let liveValue: AuthFacade = {
        @Dependency(\.loginUseCase) var loginUseCase
        @Dependency(\.logoutUseCase) var logoutUseCase
        @Dependency(\.reauthenticateUseCase) var reauthenticateUseCase
        @Dependency(\.deleteAccountUseCase) var deleteAccountUseCase
        @Dependency(\.observeAuthStateUseCase) var observeAuthStateUseCase
        
        return AuthFacade(loginUseCase: loginUseCase,
                          logoutUseCase: logoutUseCase,
                          reauthenticateUseCase: reauthenticateUseCase,
                          deleteAccountUseCase: deleteAccountUseCase,
                          observeAuthStateUseCase: observeAuthStateUseCase)
    }()
}

extension DependencyValues {
    var userSyncService: UserSyncService {
        get { self[UserSyncServiceKey.self] }
        set { self[UserSyncServiceKey.self] = newValue }
    }
    
    var authFacade: AuthFacade {
        get { self[AuthFacadeKey.self] }
        set { self[AuthFacadeKey.self] = newValue }
    }
    
}

