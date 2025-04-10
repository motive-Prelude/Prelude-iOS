//
//  RepositoryError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//

import Foundation

enum RepositoryError: Error {
    case invalidCredential
    case networkError
    case cloudDataNotFound
    case localDataNotFound
    case dataParsingError
    case conflict
    case timeout
    case unknownError
}
