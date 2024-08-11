//
//  UploadImageUseCase.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import UIKit
import Combine

final class UploadImageUseCase {
    private let repository: ImageRepository
    
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    func execute(_ image: UIImage) -> AnyPublisher<FileUploadResponse, Error> {
        return repository.uploadImage(image: image)
    }
}
