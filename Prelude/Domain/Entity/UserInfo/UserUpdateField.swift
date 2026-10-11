//
//  UserUpdateField.swift
//  Prelude
//
//  Created by 송지혁 on 4/6/25.
//


enum UserUpdateField {
    case remainingTimes(Int)
    case incrementRemainingTimes(Int)
    case healthInfo(HealthInfo)
    case termsAndConditions
    case markGiftAsReceived
}
