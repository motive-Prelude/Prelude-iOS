//
//  SignpostLogger.swift
//  Prelude
//
//  Created by 송지혁 on 3/24/25.
//

import Foundation
import os

enum SignpostLogger {
    
    static func measure<T>(
        subsystem: String = Bundle.main.bundleIdentifier ?? "com.unknown.app",
        category: String = "PointsOfInterest",
        name: StaticString,
        _ block: () async throws -> T
    ) async rethrows -> T {
        let log = OSLog(subsystem: subsystem, category: category)
        let signpostID = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
        defer {
            os_signpost(.end, log: log, name: name, signpostID: signpostID)
        }
        return try await block()
    }
    
    static func measure<T>(
        subsystem: String = Bundle.main.bundleIdentifier ?? "com.unknown.app",
        category: String = "PointsOfInterest",
        name: StaticString,
        _ block: () throws -> T
    ) rethrows -> T {
        let log = OSLog(subsystem: subsystem, category: category)
        let signpostID = OSSignpostID(log: log)
        os_signpost(.begin, log: log, name: name, signpostID: signpostID)
        defer {
            os_signpost(.end, log: log, name: name, signpostID: signpostID)
        }
        return try block()
    }
}


