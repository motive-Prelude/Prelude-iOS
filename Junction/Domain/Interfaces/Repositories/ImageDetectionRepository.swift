//
//  ImageDetectionRepository.swift
//  Junction
//
//  Created by 송지혁 on 11/9/24.
//

import UIKit

protocol ImagePredictionRepository {
    func predictFood(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
}
