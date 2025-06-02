//
//  LoginUseCaseKey.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture


private enum LoginUseCaseKey: DependencyKey {
    static let liveValue: LoginUseCase = {
        @Dependency(\.firebaseAuthRepository) var firebaseAuthRepository
        @Dependency(\.userSyncService) var userSyncService
        
        return LoginUseCase(authRepository: firebaseAuthRepository, userSyncService: userSyncService)
    }()
}

private enum LogoutUseCaseKey: DependencyKey {
    static let liveValue: LogOutUseCase = {
        @Dependency(\.firebaseAuthRepository) var firebaseAuthRepository
        
        return LogOutUseCase(authRepository: firebaseAuthRepository)
    }()
}

private enum ObserveAuthStateUseCaseKey: DependencyKey {
    static let liveValue: ObserveAuthStateUseCase = {
        @Dependency(\.firebaseAuthRepository) var firesbaseAuthRepository
        
        return ObserveAuthStateUseCase(authRepository: firesbaseAuthRepository)
    }()
}

private enum ReauthenticateUseCaseKey: DependencyKey {
    static let liveValue: ReauthenticateUseCase = {
        @Dependency(\.firebaseAuthRepository) var firebaseAuthRepository
        
        return ReauthenticateUseCase(authRepository: firebaseAuthRepository)
    }()
}

private enum DeleteAccountUseCaseKey: DependencyKey {
    static let liveValue: DeleteAccountUseCase = {
        @Dependency(\.firebaseAuthRepository) var firebaseAuthRepository
        @Dependency(\.userSyncService) var userSyncService
        
        return DeleteAccountUseCase(authRepository: firebaseAuthRepository, userSyncService: userSyncService)
    }()
}

private enum FetchUserInfoUseCaseKey: DependencyKey {
    static let liveValue: FetchUserInfoUseCase = {
        @Dependency(\.userSyncService) var userSyncService
        
        return FetchUserInfoUseCase(userSyncService: userSyncService)
    }()
}

private enum DiagnoseFoodUseCaseKey: DependencyKey {
    static let liveValue: DiagnoseFoodUseCase = {
        @Dependency(\.geminiChatRepository) var geminiChatRepository
        
        return DiagnoseFoodUseCase(repository: geminiChatRepository)
    }()
}

private enum SearchFoodInformationUseCaseKey: DependencyKey {
    static let liveValue: SearchFoodInformationUseCase = {
        @Dependency(\.geminiChatRepository) var geminiChatRepository
        
        return SearchFoodInformationUseCase(repository: geminiChatRepository)
        
    }()
}

private enum UpdateUserInfoUseCaseKey: DependencyKey {
    static let liveValue: UpdateUserInfoUseCase = {
        @Dependency(\.userSyncService) var userSyncService
        
        return UpdateUserInfoUseCase(service: userSyncService)
        
    }()
}

private enum AddCurrencyUseCaseKey: DependencyKey {
    static let liveValue: AddCurrencyUseCase = {
        @Dependency(\.userSyncService) var userSyncService
        
        return AddCurrencyUseCase(service: userSyncService)
    }()
}

private enum SaveUserInfoUseCaseKey: DependencyKey {
    static let liveValue: SaveUserInfoUseCase = {
        @Dependency(\.userSyncService) var userSyncService
        
        return SaveUserInfoUseCase(service: userSyncService)
    }()
}

extension DependencyValues {
    
    var loginUseCase: LoginUseCase {
        get { self[LoginUseCaseKey.self] }
        set { self[LoginUseCaseKey.self] = newValue }
    }
    
    var logoutUseCase: LogOutUseCase {
        get { self[LogoutUseCaseKey.self] }
        set { self[LogoutUseCaseKey.self] = newValue }
    }
    
    var reauthenticateUseCase: ReauthenticateUseCase {
        get { self[ReauthenticateUseCaseKey.self] }
        set { self[ReauthenticateUseCaseKey.self] = newValue }
    }
    
    var deleteAccountUseCase: DeleteAccountUseCase {
        get { self[DeleteAccountUseCaseKey.self] }
        set { self[DeleteAccountUseCaseKey.self] = newValue }
    }
    
    var observeAuthStateUseCase: ObserveAuthStateUseCase {
        get { self[ObserveAuthStateUseCaseKey.self] }
        set { self[ObserveAuthStateUseCaseKey.self] = newValue }
    }
    
    var fetchUserInfoUseCase: FetchUserInfoUseCase {
        get { self[FetchUserInfoUseCaseKey.self] }
        set { self[FetchUserInfoUseCaseKey.self] = newValue }
    }
    
    var diagnoseFoodUseCase: DiagnoseFoodUseCase {
        get { self[DiagnoseFoodUseCaseKey.self] }
        set { self[DiagnoseFoodUseCaseKey.self] = newValue }
    }
    
    var searchFoodInformationUseCase: SearchFoodInformationUseCase {
        get { self[SearchFoodInformationUseCaseKey.self] }
        set { self[SearchFoodInformationUseCaseKey.self] = newValue }
    }
    
    var updateUserInfoUseCase: UpdateUserInfoUseCase {
        get { self[UpdateUserInfoUseCaseKey.self] }
        set { self[UpdateUserInfoUseCaseKey.self] = newValue }
    }
    
    var saveUserInfoUseCase: SaveUserInfoUseCase {
        get { self[SaveUserInfoUseCaseKey.self] }
        set { self[SaveUserInfoUseCaseKey.self] = newValue }
    }
    
    var addCurrencyUseCase: AddCurrencyUseCase {
        get { self[AddCurrencyUseCaseKey.self] }
        set { self[AddCurrencyUseCaseKey.self] = newValue }
    }
}
