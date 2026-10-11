//
//  MeasurableUnit.swift
//  Junction
//
//  Created by 송지혁 on 12/6/24.
//


protocol MeasurableUnit: Hashable, Codable {
    associatedtype Value: Equatable & FloatingPoint
    
    var symbol: String { get }
    var subUnits: [Self] { get }
    var placeholder: String { get }
    var maxLength: Int { get }
    
    func toBaseUnit(_ value: Value) -> Value
    func fromBaseUnit(_ value: Value) -> Value
    func toString(_ value: Value) -> String
    func fromString(_ string: String) -> Value?
    
}

extension MeasurableUnit {
    var subUnits: [Self] {
        switch self {
            default: [self]
        }
    }
}
