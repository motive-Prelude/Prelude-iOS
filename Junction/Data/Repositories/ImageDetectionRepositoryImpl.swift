//
//  ImageDetectionRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/9/24.
//

import CoreML
import UIKit
import Vision

final class ImagePredictionRepositoryImpl: ImagePredictionRepository {
    private let model: FoodDetection
    
    init(model: FoodDetection) {
        self.model = model
    }
    
    func predictFood(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else { return completion(.failure(CancellationError())) }
        let model = try! VNCoreMLModel(for: model.model)
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let firstResult = results.first else { return completion(.failure(CancellationError())) }
            
            completion(.success(firstResult.identifier))
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }
}
