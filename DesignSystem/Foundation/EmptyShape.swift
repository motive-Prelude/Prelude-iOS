//
//  EmptySHape.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct EmptyShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path()
    }
}
