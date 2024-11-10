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
    
    func uploadImage(image: UIImage) async throws -> FileUploadResponse {
        guard let url = URL(string: EndPoint.uploadFile.urlString) else { throw URLError(.badURL) }
        let result: FileUploadResponse = try await apiService.uploadImage(to: url, image: image)
        
        return result
    }
}
