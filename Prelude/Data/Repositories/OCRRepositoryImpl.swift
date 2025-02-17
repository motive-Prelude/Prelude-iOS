//
//  OCRRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 11/15/24.
//

import UIKit
import Vision

class OCRRepositoryImpl: OCRRepository {
    
    func performOCR(on image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let cgImage = image.cgImage else { return completion(.failure(CancellationError()) )}
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error { completion(.failure(error)) }
            
            let texts = request.results?.compactMap {
                ($0 as? VNRecognizedTextObservation)?.topCandidates(10).map { $0.string }
            }
            
            guard let recognizedTexts = texts else { return completion(.failure(CancellationError())) }
            
            completion(.success(recognizedTexts[0]))
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}
