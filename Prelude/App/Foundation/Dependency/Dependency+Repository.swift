//
//  Dependency+Repository.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture

private enum ICloudUserRepositoryKey: DependencyKey {
    
    static let liveValue: ICloudUserRepository = {
        @Dependency(\.iCloudDataSource) var iCloudDataSource
        
        return ICloudUserRepository(iCloudDataSource: iCloudDataSource)
    }()
}

private enum FirestoreUserRepositoryKey: DependencyKey {
    static let liveValue: FirestoreUserRepository = {
        @Dependency(\.firestoreUserDataSource) var firestoreUserDataSource
        
        return FirestoreUserRepository(dataSource: firestoreUserDataSource)
    }()
}

private enum FirebaseAuthRepositoryKey: DependencyKey {
    static let liveValue: FirebaseAuthRepository = {
        @Dependency(\.firebaseAuthDataSource) var firebaseAuthDataSource
        
        return FirebaseAuthRepository(dataSource: firebaseAuthDataSource)
    }()
}

private enum AuthRepositoryKey: DependencyKey {
    static let liveValue: AuthRepository = {
        @Dependency(\.firebaseAuthDataSource) var firebaseAuthDataStore
        
        return FirebaseAuthRepository(dataSource: firebaseAuthDataStore)
    }()
}

private enum SwiftDataUserRepositoryKey: DependencyKey {
    static let liveValue: SwiftDataUserRepository = {
        @Dependency(\.swiftDataSource) var swiftDataSource
        
        return SwiftDataUserRepository(dataSource: swiftDataSource)
    }()
}

private enum GeminiChatRepositoryKey: DependencyKey {
    static let liveValue: GeminiChatRepository = {
        @Dependency(\.apiClient) var apiClient
        
        return GeminiChatRepository(apiClient: apiClient)
    }()
}

extension DependencyValues {
    
    var firestoreUserRepository: FirestoreUserRepository {
        get { self[FirestoreUserRepositoryKey.self] }
        set { self[FirestoreUserRepositoryKey.self] = newValue }
    }
    
    var iCloudUserRepository: ICloudUserRepository {
        get { self[ICloudUserRepositoryKey.self] }
        set { self[ICloudUserRepositoryKey.self] = newValue }
    }
    
    var swiftDataUserRepository: SwiftDataUserRepository {
        get { self[SwiftDataUserRepositoryKey.self] }
        set { self[SwiftDataUserRepositoryKey.self] = newValue }
    }
    
    var firebaseAuthRepository: FirebaseAuthRepository {
        get { self[FirebaseAuthRepositoryKey.self] }
        set { self[FirebaseAuthRepositoryKey.self] = newValue }
    }
    
    var geminiChatRepository: GeminiChatRepository {
        get { self[GeminiChatRepositoryKey.self] }
        set { self[GeminiChatRepositoryKey.self] = newValue }
    }
}
