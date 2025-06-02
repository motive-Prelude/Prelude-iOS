//
//  AlertAction.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//

import SwiftUI

struct AlertAction: Identifiable {
    let id = UUID()
    let title: String
    var directionalColor: Color?
    let action: () -> Void
}
