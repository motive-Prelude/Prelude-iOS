//
//  Weight.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import Foundation


enum WeightUnit: String, MeasurableUnit {
    typealias Value = Double
    
    case kilogram = "kg"
    case pound = "lb"
    
    var symbol: String { self.rawValue }
    
    var maxLength: Int {
        switch self {
            case .kilogram: 3
            case .pound: 3
        }
    }
    
    var placeholder: String {
        switch self {
            case .kilogram: "Weight (kg)"
            case .pound: "Weight (lb)"
        }
    }
    
    func toBaseUnit(_ value: Double) -> Double {
        switch self {
            case .kilogram: return value
            case .pound: return value * 0.453592
        }
    }
    
    func fromBaseUnit(_ value: Double) -> Double {
        switch self {
            case .kilogram: return value
            case .pound: return value / 0.453592
        }
    }
    
    func toString(_ value: Double) -> String {
        if value == floor(value) { return String(Int(value)) }
        else { return String(format: "%.2f", value) }
    }
    
    func fromString(_ string: String) -> Double? {
        Double(string)
    }
}

struct Weight: Measurable {
    var value: Double
    var unit: WeightUnit
    
    init(_ value: Double, _ unit: WeightUnit) {
        self.value = value
        self.unit = unit
    }
    
}
