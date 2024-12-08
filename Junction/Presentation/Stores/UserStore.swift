//
//  UserStore.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Foundation

class UserStore: ObservableObject {
    static let shared = UserStore()
    
    @Published var userInfo: UserInfo?
    
    private let userRepository: UserRepositoryImpl
    
    private init(userRepository: UserRepositoryImpl = UserRepositoryImpl()) {
        self.userRepository = userRepository
        
        Task { await fetchUserInfo() }
    }
    
    func fetchUserInfo() async {
        do {
            self.userInfo = try await userRepository.fetchUserInfo()
        } catch .cloudDataNotFound {
            
        } catch .localDataNotFound {
            
        } catch .dataParsingError {
            
        } catch  {
            
        }
    }
    
    func updateUserInfo(_ userInfo: UserInfo) async {
        await userRepository.updateUserInfo(newInfo: userInfo)
    }
}
