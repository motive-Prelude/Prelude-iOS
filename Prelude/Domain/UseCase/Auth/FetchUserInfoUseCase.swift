//
//  FetchUserInfoUseCase.swift
//  Prelude
//
//  Created by 송지혁 on 5/11/25.
//

import Foundation

final class FetchUserInfoUseCase {
    private let userSyncService: UserSyncService
    
    init(userSyncService: UserSyncService) {
        self.userSyncService = userSyncService
    }
    
    func execute(userID: String) async throws(DomainError) -> UserInfo {
        try await userSyncService.fetch(id: userID, from: .active)
    }
}
