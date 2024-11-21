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
    private let performOCRUseCase: PerformOCRUseCase
    private let predictFoodUseCase: PredictFoodUseCase
    private let predictFoodTextUseCase: PredictFoodTextUseCase
    private let imageClassifierUseCase: ImageClassifierUseCase
    
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
         performOCRUseCase: PerformOCRUseCase = DIContainer.shared.resolve(PerformOCRUseCase.self)!,
         predictFoodUseCase: PredictFoodUseCase = DIContainer.shared.resolve(PredictFoodUseCase.self)!,
         predictFoodTextUseCase: PredictFoodTextUseCase = DIContainer.shared.resolve(PredictFoodTextUseCase.self)!,
         imageClassifierUseCase: ImageClassifierUseCase = DIContainer.shared.resolve(ImageClassifierUseCase.self)!,
         cloudKitManager: CloudKitManager = CloudKitManager.shared,
         userStore: UserStore = .shared
    ) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
        self.performOCRUseCase = performOCRUseCase
        self.predictFoodUseCase = predictFoodUseCase
        self.cloudkitManager = cloudKitManager
        self.userStore = userStore
        self.predictFoodTextUseCase = predictFoodTextUseCase
        self.imageClassifierUseCase = imageClassifierUseCase
    }
    
    
    func checkRemainingTimes() async -> Bool {
        await self.userStore.fetchUserInfo()
        guard let userInfo = userStore.userInfo else { return false }
        
        //        if newUserInfo.remainingTimes < 1 {
        //            return false
        //        }
        
        userInfo.remainingTimes -= 1
        
        let newUserInfo = UserInfo(remainingTimes: userInfo.remainingTimes, healthInfo: userInfo.healthInfo)
        await userStore.updateUserInfo(newUserInfo)
        
        return true
    }
    
    private func extractText(in image: UIImage, completion: @escaping ([String]) -> Void) {
        performOCRUseCase.execute(image: image) { result in
            switch result {
                case .success(let text):
                    completion(text)
                    return
                case .failure(let error):
                    print(error)
                    return
            }
        }
    }
    
    func detectFoodOrNot(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let result = imageClassifierUseCase.classify(image: image) else {
            print("문제 생김")
            completion(false)
            return
        }
        if result == "a Nonfood" {
            print("음식 아니다")
            completion(false)
        }
        else {
            print("음식이다")
            completion(true)
        }
        
//        predictFoodUseCase.execute(with: image) { result in
//            switch result {
//                case .success(let foodType):
//                    print(foodType)
//                    if foodType == "Nonfood" {
//                        self.extractText(in: image) { texts in
//                            if self.detectFoodTextOrNot(texts: texts) {
//                                print("음식 텍스트 인식")
//                                completion(true)
//                            }
//                            else {
//                                print("음식이 아닌 텍스트")
//                                completion(false)
//                            }
//                        }
//                        return
//                        
//                    } else {
//                        completion(true)
//                        return
//                    }
//                case .failure:
//                    completion(false)
//                    return
//            }
//        }
    }
    
    private func detectFoodTextOrNot(texts: [String]) -> Bool {
        predictFoodTextUseCase.execute(texts: texts)
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
