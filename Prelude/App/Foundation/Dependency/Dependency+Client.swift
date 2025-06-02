//
//  Dependency+Client.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//

import ComposableArchitecture

private enum APIClientKey: DependencyKey {
    static let liveValue: APIClient = {
        return APIClient()
    }()
}

private enum StoreKitClientKey: DependencyKey {
    static let liveValue: StoreKitClient = {
        return StoreKitClient()
    }()
}

private enum NetworkMonitorKey: DependencyKey {
    static let liveValue: NetworkMonitorClient = {
        return NetworkMonitorClient()
    }()
}

extension DependencyValues {
    
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
    
    var networkMonitor: NetworkMonitorClient {
        get { self[NetworkMonitorKey.self] }
        set { self[NetworkMonitorKey.self] = newValue }
    }
    
    var storekitClient: StoreKitClient {
        get { self[StoreKitClientKey.self] }
        set { self[StoreKitClientKey.self] = newValue }
    }
}
