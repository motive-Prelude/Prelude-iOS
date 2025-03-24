//
//  PerplexityRequest.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import Foundation

struct PerplexityRequest<T: Decodable>: APIRequest {
    typealias E = PerplexityEndPoint
    typealias Response = T
    
    var baseURL: URL { URL(string: "https://api.perplexity.ai")! }
    let endpoint: PerplexityEndPoint
}
