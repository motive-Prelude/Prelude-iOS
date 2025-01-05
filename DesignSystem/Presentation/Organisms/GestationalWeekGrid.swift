//
//  GestationalWeekGrid.swift
//  Junction
//
//  Created by 송지혁 on 12/30/24.
//

import SwiftUI

struct GestationalWeekGrid: View {
    
    @State var gestationalWeek: GestationalWeek?
    
    let result: (GestationalWeek?) -> ()
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(GestationalWeek.allCases, id: \.self) { week in
                PLFormButton(label: week.rawValue,
                             description: week.weeks,
                             isSelected: bindingForWeek(week),
                             contentType: .description,
                             mode: .stretch,
                             onTap: {
                    withAnimation {
                        result(gestationalWeek)
                    }
                })
            }
        }
    }
    
    private func bindingForWeek(_ week: GestationalWeek) -> Binding<Bool> {
        Binding(
            get: { gestationalWeek == week },
            set: { isSelected in
                gestationalWeek = isSelected ? week : nil
            }
        )
    }
}

#Preview {
    GestationalWeekGrid() { week in }
}
