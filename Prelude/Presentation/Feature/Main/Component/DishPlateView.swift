//
//  DishPlateView.swift
//  Prelude
//
//  Created by 송지혁 on 5/27/25.
//

import SwiftUI

struct DishPlateView: View {
    let image: UIImage?
    let onRetake: () -> Void
    let onRemove: () -> Void
    let onCapture: () -> Void
    
    var body: some View {
        ZStack {
            Image(.dish)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 360, height: 360)
                .padding(.top, 4)
                .overlay {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 136)
                            .clipShape(Circle())
                            .padding(.top, -6)
                            .overlay(alignment: .top) {
                                HStack {
                                    redoButton
                                    Spacer()
                                    closeButton
                                }
                            }
                    } else {
                        VStack(spacing: 4) {
                            captureButton
                                                
                            Text(Localization.Label.takePhotoLabel)
                                .textStyle(.title1)
                                .foregroundStyle(PLColor.neutral800)
                        }
                    }
                }
        }
    }
    
    private var redoButton: some View {
        PLActionButton(icon: Image(.redo),
                       type: .secondary,
                       contentType: .icon,
                       size: .xsmall,
                       shape: .square) { onRetake() }
    }
    
    private var closeButton: some View {
        PLActionButton(icon: Image(.closeSmall),
                       type: .secondary,
                       contentType: .icon,
                       size: .xsmall,
                       shape: .square) { onRemove() }
    }
    
    private var captureButton: some View {
        PLActionButton(icon: Image(.capture),
                       type: .primary,
                       contentType: .icon,
                       size: .medium,
                       shape: .circle) { onCapture() }

    }
}
