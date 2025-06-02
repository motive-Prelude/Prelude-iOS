//
//  GeminiChatRepository.swift
//  Prelude
//
//  Created by 송지혁 on 2/2/25.
//

import FirebaseFunctions
import UIKit

final class GeminiChatRepository: ChatAIRepository {
    private let apiClient: APIClient
    private let functions = Functions.functions()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetch<T: Decodable>(image: UIImage?, messages: [String], as type: T.Type) async throws(DomainError) -> (T, [Citation]) {
        let imageData = image?.jpegData(compressionQuality: 0.7)
        let base64String = imageData?.base64EncodedString() ?? ""
        let request = GeminiRequest<GeminiResponse>(endpoint: .chat(prompt: messages, image: base64String))
        
        do {
            let response = try await apiClient.send(request)
            guard let data = response.answer.data(using: .utf8) else { throw DomainError.serverError }
            let result = try JSONDecoder().decode(type, from: data)
            return (result, response.citations)
        } catch { throw DomainError.serverError }
    }
}
