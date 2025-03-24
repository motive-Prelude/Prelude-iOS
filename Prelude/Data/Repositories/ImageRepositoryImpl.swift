//
//  ImageRepositoryImpl.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import UIKit
import Combine

final class ImageRepositoryImpl: ImageRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func uploadImage(image: UIImage) async throws(DomainError) -> FileUploadResponse {
        guard let url = URL(string: OpenAIEndPoint.uploadFile.urlString) else { throw .unknown }
        do {
            let result: FileUploadResponse = try await apiClient.uploadImage(to: url, image: image)
            return result
        } catch { throw ErrorMapper.map(error) }
    }
}
