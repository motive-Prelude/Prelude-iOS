//
//  Shape.swift
//  Junction
//
//  Created by 송지혁 on 11/28/24.
//

import SwiftUI

enum ButtonShape: Hashable {
    case rect
    case circle
    case none
    case square
    case pill
    
    func backgroundShape() -> some Shape {
        switch self {
            case .rect, .square:
                AnyShape(Rectangle())
            case .circle:
                AnyShape(Circle())
            case .none:
                AnyShape(EmptyShape())
            case .pill:
                AnyShape(Capsule())
        }
    }
}
