//
//  APIService.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import UIKit
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH, HEAD
}

enum HTTPBody {
    case json(Encodable)
    case data(Data, contentType: String)
}

final class APIService {
    func fetchData<T: Decodable>(with request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        } catch {
            throw APIError.unknown
        }
    }
    
    func makeURLRequest(to url: URL,
                        method: HTTPMethod = .POST,
                        headers: [String: String] = [:],
                        body: HTTPBody? = nil
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        setCommonHeaders(for: &request)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body {
            switch body {
                case .json(let encodable):
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try JSONEncoder().encode(encodable)
                case .data(let data, let contentType):
                    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                    request.httpBody = data
            }
        }
        
        return request
    }
    
    func uploadImage(withURL urlString: String, _ image: UIImage, purpose: String = "vision", fileName: String = "image.jpeg") -> AnyPublisher<FileUploadResponse, Error> {
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        setCommonHeaders(for: &request)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(with: image, boundary: boundary, purpose: purpose, fileName: fileName)
        
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: FileUploadResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Multipart body를 생성하는 메서드
    private func createMultipartBody(with image: UIImage, boundary: String, purpose: String, fileName: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // purpose 필드 추가
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"purpose\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(purpose)\r\n".data(using: .utf8)!)
        
        // 파일 데이터 추가
        let imageData = image.jpegData(compressionQuality: 1.0) ?? Data()
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private func setCommonHeaders(for request: inout URLRequest) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
    }
    
    func createThreadBody(role: String, messages: [String], fileId: String?) -> MessageBody {
        var messageContents = [MessageContent]()
        
        if let fileId = fileId {
            let imageContent = MessageContentData(type: "image_file", text: nil, imageFile: ImageFileContent(fileID: fileId, detail: "high"))
            messageContents.append(MessageContent(role: role, content: [imageContent]))
        }
        
        for message in messages {
            let textContent = MessageContentData(type: "text", text: message, imageFile: nil)
            messageContents.append(MessageContent(role: role, content: [textContent]))
        }
        
        return MessageBody(messages: messageContents)
    }
    
    func createMessageBody(role: String, text: String?, fileId: String?) -> MessageBody {
        var body = MessageBody(messages: [])
        
        if let fileId = fileId {
            let imageContent = MessageContentData(type: "image_file", text: nil, imageFile: ImageFileContent(fileID: fileId, detail: "high"))
            body.messages.append(MessageContent(role: role, content: [imageContent]))
        } else if let text = text {
            let textContent = MessageContentData(type: "text", text: text, imageFile: nil)
            body.messages.append(MessageContent(role: role, content: [textContent]))
        } else {
            let errorContent = MessageContentData(type: "text", text: "오류 발생", imageFile: nil)
            body.messages.append(MessageContent(role: role, content: [errorContent]))
        }
        
        return body
    }
    
    func createRunBody(assistantID: String) -> RunRequest {
        return RunRequest(assistantID: assistantID)
    }
}

