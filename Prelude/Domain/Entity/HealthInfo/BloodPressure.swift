//
//  BloodPressure.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


enum BloodPressure: String, Codable {
    case none = "None"
    case hypotension = "Hypotension"
    case hypertension = "Hypertension"
    case noResponse = "No response"
}