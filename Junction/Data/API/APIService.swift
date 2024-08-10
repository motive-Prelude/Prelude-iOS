//
//  APIService.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import Foundation

final class APIService {
    func fetchData<T: Decodable>(with request: URLRequest) -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createRequest<T: Encodable>(withURL urlString: String, method: String = "POST", body: T?) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        setCommonHeaders(for: &request)
        
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return request
    }
    
    private func setCommonHeaders(for request: inout URLRequest) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
    }
    
    func createThreadBody(role: String, messages: [String]) -> MessageBody {
        var body = MessageBody(messages: [])
        
        for message in messages {
            body.messages.append(.init(role: role, content: message))
        }
        
        return body
    }
    
    func createMessageBody(role: String, content: String) -> MessageContent {
        return MessageContent(role: role, content: content)
    }
    
    func createRunBody(assistantID: String) -> RunRequest {
        return RunRequest(assistantID: assistantID)
    }
}

