//
//  PerformOCRUseCase.swift
//  Junction
//
//  Created by 송지혁 on 11/15/24.
//

import UIKit

final class PerformOCRUseCase {
    private let ocrRepository: OCRRepository
    
    init(ocrRepository: OCRRepository) {
        self.ocrRepository = ocrRepository
    }
    
    func execute(image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        ocrRepository.performOCR(on: image, completion: completion)
    }
}
