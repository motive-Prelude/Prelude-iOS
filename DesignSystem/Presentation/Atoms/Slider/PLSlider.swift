//
//  PLSlider.swift
//  Junction
//
//  Created by 송지혁 on 12/31/24.
//

import SwiftUI

struct PLSlider: View {
    let minValue = 0
    let maxValue = 100
    let steps = 10
    
    @State private var handleOffset: CGFloat = -12
    @State private var dragStartOffset: CGFloat = -12
    @State private var barWidth: CGFloat = 0
    @Binding var selectedValue: Int
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .leading) {
                bar
                    .background(GeometryReaderWidthPreference())
                    .onPreferenceChange(WidthPreferenceKey.self) { width in
                        barWidth = width
                    }
                    .overlay(alignment: .leading) { datumPoint }
                    .overlay(alignment: .leading) { handle }
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("\(minValue)")
                    .textStyle(.caption)
                    .foregroundStyle(PLColor.neutral600)
                
                Spacer()
                
                Text("\(maxValue)")
                    .textStyle(.caption)
                    .foregroundStyle(PLColor.neutral600)
            }
        }
    }
    
    private var bar: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(PLColor.neutral200)
                .frame(height: 8)
            
            Capsule()
                .foregroundStyle(PLColor.neutral800)
                .frame(width: handleOffset + 12, height: 8)
        }
    }
    
    private var handle: some View {
        ZStack {
            Circle()
                .fill(PLColor.neutral800)
                .frame(width: 28, height: 28)
            
            Circle()
                .fill(PLColor.neutral50)
                .frame(width: 24, height: 24)
        }
        .offset(x: handleOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let stepWidth = (barWidth - 10) / CGFloat(steps)
                    
                    let newOffset = dragStartOffset + value.translation.width
                    let clampedOffset = min(max(newOffset, -12), barWidth - 10)
                    
                    let stepIndex = (clampedOffset / stepWidth).rounded()
                    
                    handleOffset = stepIndex * stepWidth - 12
                    
                    selectedValue = Int(stepIndex) * (maxValue - minValue) / (steps)
                }
                .onEnded { _ in
                    dragStartOffset = handleOffset
                }
        )
    }
    
    private var datumPoint: some View {
        return HStack(alignment: .center, spacing: barWidth / CGFloat(steps+2)) {
            ForEach(0..<steps+1, id: \.self) { _ in
                Circle()
                    .fill(PLColor.neutral50)
                    .frame(width: 4, height: 4)
            }
        }
        .padding(.leading, 2)
        
    }
}

struct GeometryReaderWidthPreference: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    @Previewable @State var selectedValue = 0
    PLSlider(selectedValue: $selectedValue)
}
