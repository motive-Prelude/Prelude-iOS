//
//  StoreError.swift
//  Prelude
//
//  Created by 송지혁 on 6/2/25.
//


enum StoreError: Error {
    case failedVerification
    case insufficientFunds
    case networkUnavailable
    case unknownError
}