//
//  Dependency+DataSource.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture

private enum FirebaseAuthDataSourceKey: DependencyKey {
    static let liveValue: FirebaseAuthDataSource = FirebaseAuthDataSource()
}

private enum FirestoreUserDataSourceKey: DependencyKey {
    static let liveValue: FirestoreDataSource = FirestoreDataSource<UserInfo>()
}

private enum ICloudDataSourceKey: DependencyKey {
    static let liveValue: ICloudDataSource = ICloudDataSource.shared
}

private enum SwiftDataSourceKey: DependencyKey {
    static let liveValue: SwiftDataSource = SwiftDataSource.shared
}

extension DependencyValues {
    
    var firebaseAuthDataSource: FirebaseAuthDataSource {
        get { self[FirebaseAuthDataSourceKey.self] }
        set { self[FirebaseAuthDataSourceKey.self] = newValue }
    }
    
    var firestoreUserDataSource: FirestoreDataSource<UserInfo> {
        get { self[FirestoreUserDataSourceKey.self] }
        set { self[FirestoreUserDataSourceKey.self] = newValue }
    }
    
    var iCloudDataSource: ICloudDataSource {
        get { self[ICloudDataSourceKey.self] }
        set { self[ICloudDataSourceKey.self] = newValue }
    }
    
    var swiftDataSource: SwiftDataSource {
        get { self[SwiftDataSourceKey.self] }
        set { self[SwiftDataSourceKey.self] = newValue }
    }
}
