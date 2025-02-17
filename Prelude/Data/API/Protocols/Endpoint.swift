//
//  Endpoint.swift
//  Prelude
//
//  Created by 송지혁 on 1/22/25.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}
