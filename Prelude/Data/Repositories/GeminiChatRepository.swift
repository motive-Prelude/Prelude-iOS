//
//  GeminiChatRepository.swift
//  Prelude
//
//  Created by 송지혁 on 2/2/25.
//

import FirebaseFunctions
import UIKit

final class GeminiChatRepository {
    private let apiClient: APIClient
    private let functions = Functions.functions()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetch(image: UIImage?, messages: [String]) async throws(DomainError) -> GeminiResponse? {
        let imageData = image?.jpegData(compressionQuality: 1)
        let base64String = imageData?.base64EncodedString() ?? ""
        let request = GeminiRequest<GeminiResponse>(endpoint: .chat(prompt: messages, image: base64String))
        
        do {
            let response = try await apiClient.send(request)
            return response
        } catch {
            print(error)
            throw DomainError.serverError
        }
    }
}
