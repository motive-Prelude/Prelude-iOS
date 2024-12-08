//
//  PLPageIndicator.swift
//  Junction
//
//  Created by 송지혁 on 11/30/24.
//

import SwiftUI

struct PLPageIndicator: View {
    @Binding var currentPage: Int
    let totalCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalCount, id: \.self) { index in
                indicator(index)
            }
        }
        .onChange(of: currentPage) { validateCurrentPage() }
    }
    
    
    private func indicator(_ index: Int) -> some View {
        Circle()
            .fill(indicatorColor(index))
            .frame(width: 4, height: 4)
            .animation(.easeInOut(duration: 0.2), value: currentPage)
    }
    private func indicatorColor(_ index: Int) -> Color {
        index == currentPage ? PLColor.neutral600 : PLColor.neutral300
    }
    private func validateCurrentPage() {
        let maxCount = totalCount - 1
        if currentPage >= maxCount { currentPage = maxCount }
    }
}

#Preview {
    @Previewable @State var currentPage = 2
    @Previewable let totalCount = 5
    
    PLPageIndicator(currentPage: $currentPage, totalCount: totalCount)
        .onTapGesture {
            if currentPage == totalCount - 1 { return }
            currentPage += 1
        }
}
