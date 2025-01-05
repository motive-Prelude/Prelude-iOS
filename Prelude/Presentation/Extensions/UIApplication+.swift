//
//  UIApplication+.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

