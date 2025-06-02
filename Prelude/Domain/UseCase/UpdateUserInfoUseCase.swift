//
//  UpdateUserInfoUseCase.swift
//  Prelude
//
//  Created by 송지혁 on 5/16/25.
//

final class UpdateUserInfoUseCase {
    let service: UserSyncService
    
    init(service: UserSyncService) {
        self.service = service
    }
    
    func execute(userInfo: UserInfo) async throws(DomainError) -> UserInfo {
        do {
            try await service.save(user: userInfo, in: .active)
            return userInfo
        } catch {
            throw error
        }
    }
}
