//
//  ButtonStyleData.swift
//  Junction
//
//  Created by 송지혁 on 11/29/24.
//

import SwiftUI

struct ActionButtonStyleData {
    let foregroundColor: Color
    let backgroundColor: Color
    var borderColor: Color = .clear
    let cornerRadius: CGFloat
    let height: CGFloat
    var sizeMode: SizeMode = .hug
    var padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    var margin: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    var shadow: ShadowStyle = .drop(color: .clear, radius: 0)
    
}
