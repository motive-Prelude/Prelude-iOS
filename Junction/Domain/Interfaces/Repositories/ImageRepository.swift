//
//  ImageRepository.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import Combine
import UIKit

protocol ImageRepository {
    func uploadImage(image: UIImage) -> AnyPublisher<FileUploadResponse, Error>
}
