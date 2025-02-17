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
    private let predictFoodTextUseCase: PredictFoodTextUseCase
    private let imageClassifierUseCase: ImageClassifierUseCase
    
    var cancellables = Set<AnyCancellable>()
    @Published var receivedMessage: String?
    @Published var imageErrorMessage: String?
    
    @Published var judgement: Judgement?
    @Published var citations: [Citation] = []
    @Published var isLoading: Bool?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl(
        createThreadAndRunUseCase: DIContainer.shared.resolve(CreateThreadAndRunUseCase.self)!,
        listRunStepUseCase: DIContainer.shared.resolve(ListRunStepUseCase.self)!,
        retrieveMessageUseCase: DIContainer.shared.resolve(RetrieveMessageUseCase.self)!,
        uploadImageUseCase: DIContainer.shared.resolve(UploadImageUseCase.self)!,
        perplexityChatUseCase: DIContainer.shared.resolve(PerplexityChatUseCase.self)!
    ),
         performOCRUseCase: PerformOCRUseCase = DIContainer.shared.resolve(PerformOCRUseCase.self)!,
         predictFoodTextUseCase: PredictFoodTextUseCase = DIContainer.shared.resolve(PredictFoodTextUseCase.self)!,
         imageClassifierUseCase: ImageClassifierUseCase = DIContainer.shared.resolve(ImageClassifierUseCase.self)!) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
        self.performOCRUseCase = performOCRUseCase
        self.predictFoodTextUseCase = predictFoodTextUseCase
        self.imageClassifierUseCase = imageClassifierUseCase
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
    }
    
    
    func sendMessage(_ message: String, image: UIImage?, healthInfo: HealthInfo?) async throws(DomainError) {
        do {
            await MainActor.run { self.isLoading = true }
            
            let (judgement, citations) = try await assistantInteractionFacade.interact(with: message, image: image, healthInfo: healthInfo)
            
            await MainActor.run {
                self.judgement = judgement
                self.citations = citations
                self.isLoading = false
            }
        } catch { throw error }
    }
}
