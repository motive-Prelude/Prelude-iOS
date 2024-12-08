//
//  OCRRepository.swift
//  Junction
//
//  Created by 송지혁 on 11/15/24.
//

import UIKit

protocol OCRRepository {
    func performOCR(on image: UIImage, completion: @escaping (Result<[String], Error>) -> Void)
    
}
