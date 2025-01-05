//
//  DataSourceError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//

import Foundation

enum DataSourceError: Error {
    case networkUnavailable
    case timeout
    case cancelled
    case notFound
    case deadlineExceeded
    case unauthenticated
    case permissionDenied
    case quotaExceeded
    case conflict
    case tooManyRequests
    case unknown
}
