//
//  RepositoryError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//

import Foundation

enum RepositoryError: Error {
    case invalidCredential
    case cloudDataNotFound
    case localDataNotFound
    case dataParsingError
    case unknownError
}
