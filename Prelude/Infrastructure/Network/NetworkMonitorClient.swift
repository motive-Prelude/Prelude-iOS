//
//  NetworkMonitor.swift
//  Prelude
//
//  Created by 송지혁 on 1/4/25.
//

import Foundation
import Network

final class NetworkMonitorClient: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private(set) var isConnected: Bool = false
    
    init() {
        isConnected = monitor.currentPath.status == .satisfied
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func checkConnection() -> Bool {
        return isConnected
    }
}
