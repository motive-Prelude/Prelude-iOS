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
    
    var cancellables = Set<AnyCancellable>()
    @Published var receivedMessage: String?
    @Published var imageErrorMessage: String?
    
    @Published var judgement: Judgement?
    @Published var citations: [Citation] = []
    @Published var isLoading: Bool?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl()) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
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
