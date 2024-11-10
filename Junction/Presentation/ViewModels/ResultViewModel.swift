//
//  ResultViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

class ResultViewModel: ObservableObject {
    private let assistantInteractionFacade: AssistantInteractionFacadeImpl
    private let predictFoodUseCase: PredictFoodUseCase
    private let cloudkitManager: CloudKitManager
    private let userStore: UserStore
    
    var cancellables = Set<AnyCancellable>()
    @Published var receivedMessage: String?
    @Published var imageErrorMessage: String?
    @Published var userHealthInfo: HealthInfo?
    
    @Published var judgement: Judgement?
    @Published var isLoading: Bool?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl(
        createThreadAndRunUseCase: DIContainer.shared.resolve(CreateThreadAndRunUseCase.self)!,
        listRunStepUseCase: DIContainer.shared.resolve(ListRunStepUseCase.self)!,
        retrieveMessageUseCase: DIContainer.shared.resolve(RetrieveMessageUseCase.self)!,
        uploadImageUseCase: DIContainer.shared.resolve(UploadImageUseCase.self)!
    ),
         predictFoodUseCase: PredictFoodUseCase = DIContainer.shared.resolve(PredictFoodUseCase.self)!,
         cloudKitManager: CloudKitManager = CloudKitManager.shared,
         userStore: UserStore = .shared
    ) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
        self.predictFoodUseCase = predictFoodUseCase
        self.cloudkitManager = cloudKitManager
        self.userStore = userStore
    }
    
    
    func checkRemainingTimes() async -> Bool {
        await self.userStore.fetchUserInfo()
        guard let userInfo = userStore.userInfo else {
            print("없나..")
            return false
        }
        print("있나")
        
        //        if newUserInfo.remainingTimes < 1 {
        //            print("작음")
        //            return false
        //        }
        
        userInfo.remainingTimes -= 1
        
        let newUserInfo = UserInfo(remainingTimes: userInfo.remainingTimes, healthInfo: userInfo.healthInfo)
        await userStore.updateUserInfo(newUserInfo)
        
        return true
    }
    
    func detectFoodOrNot(image: UIImage, completion: @escaping (Bool) -> Void) {
        predictFoodUseCase.execute(with: image) { result in
            switch result {
                case .success(let foodType):
                    print(foodType)
                    if foodType == "Nonfood" {
                        print("음식 아님")
                        completion(false)
                        return
                        
                    } else {
                        print("음식임")
                        completion(true)
                        return
                    }
                case .failure:
                    completion(false)
                    return
            }
        }
    }
    
    func sendMessage(_ message: String, image: UIImage?) async -> Bool {
        do {
            await MainActor.run {
                self.isLoading = true
            }
            
            let result = try await assistantInteractionFacade.interact(with: message, image: image)
            
            await MainActor.run {
                self.judgement = result
                self.isLoading = false
            }
            
            return true
        } catch {
            
        }
        
        return false
    }
}
