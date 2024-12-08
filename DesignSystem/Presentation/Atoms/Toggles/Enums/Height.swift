//
//  Height.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import Foundation

enum HeightUnit: String, MeasurableUnit {
    case centimeter = "cm"
    case feet = "ft"
    case inch = "in"
    
    var symbol: String { self.rawValue }
    var subUnits: [HeightUnit] {
        switch self {
            case .feet: [.feet, .inch]
            default: [self]
        }
    }
    
    var placeholder: String {
        switch self {
            case .centimeter: "Height (cm)"
            case .feet: "Height (ft)"
            case .inch: "Height (in)"
        }
    }
    
    var conversionFactorToCentimeter: Double {
        switch self {
            case .centimeter: return 1.0
            case .feet: return 30.48
            case .inch: return 2.54
        }
    }
    
    func toBaseUnit(_ value: Double) -> Double {
        return value * conversionFactorToCentimeter
    }

    func fromBaseUnit(_ value: Double) -> Double {
        return value / conversionFactorToCentimeter
    }
    
    func convertToFeetAndInches(cm: Double) -> (feet: Int, inches: Int) {
        let totalInches = cm / 2.54
        let feet = Int(totalInches / 12)
        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        return (feet, inches)
    }
    
    func toString(_ value: Double) -> String {
        if value == floor(value) { return String(Int(value)) }
        else { return String(format: "%.2f", value) }
    }
    
    func fromString(_ string: String) -> Double? {
        return Double(string)
    }
}

struct Height: Measurable {
    var value: Double
    var unit: HeightUnit
}
