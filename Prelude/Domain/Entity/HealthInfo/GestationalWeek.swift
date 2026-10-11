//
//  GestationalWeek.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


enum GestationalWeek: String, CaseIterable, Codable {
    case early = "1st trimester"
    case mid = "2nd trimester"
    case late = "3rd trimester"
    case postpartum = "Postpartum"
    case noResponse = "No response"
    
    static var allCases: [GestationalWeek] {
        return [.early, .mid, .late, .postpartum]
    }
}