//
//  GeminiRequest.swift
//  Prelude
//
//  Created by 송지혁 on 2/7/25.
//

import Foundation

struct GeminiRequest<T: Decodable>: APIRequest {
    typealias E = GeminiEndPoint
    typealias Response = T
    
    var baseURL: URL { URL(string: "https://generate-ground-content-osj34uexca-uc.a.run.app")! }
    let endpoint: E
}
