//
//  Selectable.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import Foundation

protocol Measurable: Hashable, Codable {
    associatedtype Unit: MeasurableUnit & Hashable
    associatedtype Value
    
    var value: Value { get set }
    var unit: Unit { get set }
}
