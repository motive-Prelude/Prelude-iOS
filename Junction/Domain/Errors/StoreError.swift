//
//  StoreError.swift
//  Junction
//
//  Created by 송지혁 on 10/7/24.
//


public enum StoreError: Error {
    case failedVerification
    case insufficientFunds
    case networkUnavailable
    case unknownError
}
