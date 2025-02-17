//
//  APIError.swift
//  Junction
//
//  Created by 송지혁 on 1/2/25.
//


enum APIError: Error {
    case networkError
    case unknown
    case timeout
    case serverError
    case cancelled
    case decodingError
}
