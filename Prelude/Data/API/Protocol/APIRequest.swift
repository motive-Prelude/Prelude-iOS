//
//  APIRequest.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import Foundation

protocol APIRequest {
    associatedtype E: EndPoint
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var endpoint: E { get }
    
    func makeURLRequest() -> URLRequest
}


extension APIRequest {
    func makeURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = endpoint.body
    
        return request
    }
}
