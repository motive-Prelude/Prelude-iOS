//
//  APIService.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import UIKit

enum APIError: Error {
    case unknown
}

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
            let (data, _) = try await URLSession.shared.data(for: request)
            
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
    ) -> URLRequest {
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
                    request.httpBody = try? JSONEncoder().encode(encodable)
                case .data(let data, let contentType):
                    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                    request.httpBody = data
            }
        }
        
        return request
    }
    
    @discardableResult
    func uploadImage(to url: URL,
                     image: UIImage,
                     purpose: String = "vision",
                     fileName: String = "image.jpeg") async throws -> FileUploadResponse {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        let bodyData = makeMultipartBody(with: image, boundary: boundary, purpose: purpose, fileName: fileName)
        let request = makeURLRequest(to: url, method: .POST, body: .data(bodyData, contentType: contentType))
        
        return try await fetchData(with: request)
        
    }
    
    // Multipart body를 생성하는 메서드
    private func makeMultipartBody(with image: UIImage, boundary: String, purpose: String, fileName: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        guard
            let boundaryPrefixData = boundaryPrefix.data(using: .utf8),
            let purposeHeaderData = "Content-Disposition: form-data; name=\"purpose\"\r\n\r\n".data(using: .utf8),
            let purposeData = "\(purpose)\r\n".data(using: .utf8),
            let fileHeaderData = "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8),
            let contentTypeData = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8),
            let imageData = image.jpegData(compressionQuality: 1.0),
            let closingBoundaryData = "--\(boundary)--\r\n".data(using: .utf8)
        else {
            return Data()
        }
        
        body.append(boundaryPrefixData)
        body.append(purposeHeaderData)
        body.append(purposeData)
        
        body.append(boundaryPrefixData)
        body.append(fileHeaderData)
        body.append(contentTypeData)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append(closingBoundaryData)
        
        return body
    }
    
    private func setCommonHeaders(for request: inout URLRequest) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
    }
    
    func makeThreadBody(role: String, messages: [String], fileId: String) -> MessageBody {
        var messageContents = [MessageContent]()
        
        if !fileId.isEmpty {
            let imageContent = MessageContentData(type: "image_file", text: nil, imageFile: ImageFileContent(fileID: fileId, detail: "high"))
            messageContents.append(MessageContent(role: role, content: [imageContent]))
        }
        
        for message in messages {
            let textContent = MessageContentData(type: "text", text: message, imageFile: nil)
            messageContents.append(MessageContent(role: role, content: [textContent]))
        }
        
        return MessageBody(messages: messageContents)
    }
    
    func makeMessageBody(role: String, text: String, fileId: String) -> MessageBody {
        var body = MessageBody(messages: [])
        
        if !fileId.isEmpty {
            let imageContent = MessageContentData(type: "image_file", text: nil, imageFile: ImageFileContent(fileID: fileId, detail: "high"))
            body.messages.append(MessageContent(role: role, content: [imageContent]))
        } else if !text.isEmpty {
            let textContent = MessageContentData(type: "text", text: text, imageFile: nil)
            body.messages.append(MessageContent(role: role, content: [textContent]))
        } else {
            let errorContent = MessageContentData(type: "text", text: "오류 발생", imageFile: nil)
            body.messages.append(MessageContent(role: role, content: [errorContent]))
        }
        
        return body
    }
    
    func makeThreadAndRunBody(assistantID: String, role: String, messages: [String], fileID: String) -> ThreadAndRunBody {
        var messageContents = [MessageContent]()
        
        if !fileID.isEmpty {
            let imageContent = MessageContentData(type: "image_file", text: nil, imageFile: ImageFileContent(fileID: fileID, detail: "high"))
            messageContents.append(MessageContent(role: role, content: [imageContent]))
        }
        
        for message in messages {
            print(message)
            let textContent = MessageContentData(type: "text", text: message, imageFile: nil)
            messageContents.append(MessageContent(role: role, content: [textContent]))
        }
        
        
        return ThreadAndRunBody(assistantID: assistantID, thread: MessageBody(messages: messageContents))
    }
    
    func createRunBody(assistantID: String) -> RunRequest {
        return RunRequest(assistantID: assistantID)
    }
}

