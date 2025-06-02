//
//  UIImage+.swift
//  Prelude
//
//  Created by 송지혁 on 5/31/25.
//


import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        
        let scaleFactor = max(widthRatio, heightRatio)
        
        let newSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
