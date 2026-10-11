//
//  Double+.swift
//  Junction
//
//  Created by 송지혁 on 12/4/24.
//

import Foundation

extension Double {
    func convertCmToFeetAndInches() -> (feet: Int, inches: Int) {
        let totalInches = self / 2.54
        let feet = Int(totalInches / 12)
        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
        return (feet, inches)
    }

}
