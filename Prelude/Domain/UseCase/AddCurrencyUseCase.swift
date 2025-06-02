//
//  AddCurrencyUseCase.swift
//  Prelude
//
//  Created by 송지혁 on 5/18/25.
//

import Foundation

final class AddCurrencyUseCase {
    let service: UserSyncService
    
    init(service: UserSyncService) {
        self.service = service
    }
    
    func execute(id: String, amount: Int) async throws(DomainError) -> UserInfo {
        return try await service.update(id: id, fields: [.incrementRemainingTimes(amount)], in: .active)
    }
}
