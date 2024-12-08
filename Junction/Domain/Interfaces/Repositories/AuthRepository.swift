//
//  AuthRepository.swift
//  Junction
//
//  Created by 송지혁 on 12/8/24.
//

import Foundation

protocol AuthRepository {
    func logIn(parameters: AuthParameter) async throws
}
