//
//  ImageRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import UIKit
import Combine

final class ImageRepositoryImpl: ImageRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func uploadImage(image: UIImage) -> AnyPublisher<FileUploadResponse, Error> {
        return apiService.uploadImage(withURL: EndPoint.uploadFile.urlString, image)
    }
}
