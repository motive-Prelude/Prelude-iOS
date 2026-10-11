//
//  Allergies.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


enum Allergies: String, CaseIterable, Codable {
    case diary = "Diary"
    case eggs = "Eggs"
    case fish = "Fish"
    case shellfish = "Shellfish"
    case treeNuts = "Tree nuts"
    case peanuts = "Peanuts"
    case wheat = "Wheat"
    case soy = "Soy"
    case gluten = "Gluten"
    
    static var totalCount: Int { Allergies.allCases.count }
}