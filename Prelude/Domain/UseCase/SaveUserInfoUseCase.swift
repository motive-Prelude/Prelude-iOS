//
//  SaveUserInfoUseCase.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

final class SaveUserInfoUseCase {
    let service: UserSyncService
    
    init(service: UserSyncService) {
        self.service = service
    }
    
    func execute(userInfo: UserInfo) async throws(DomainError) {
        try await service.save(user: userInfo, in: .active)
    }
}
