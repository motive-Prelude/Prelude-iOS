//
//  MainViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import AppTrackingTransparency
import Combine
import UIKit
import SwiftUI

class MainViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let promptGenerator: PromptGenerator
    
    @Published var prompt = ""
    
    init(promptGenerator: PromptGenerator = PromptGenerator()) {
        self.promptGenerator = promptGenerator
    }
    
    func bind(userSession: UserSession) {
        self.prompt = self.promptGenerator.generatePrompt(with: userSession.userInfo?.healthInfo)
        
        userSession.$userInfo
            .compactMap { $0?.healthInfo }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] healthInfo in
                guard let self = self else { return }
                self.prompt = self.promptGenerator.generatePrompt(with: healthInfo)
            }
            .store(in: &cancellables)
    }
    
    func requestTrackingAuthorizationIfNeeded() {
        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .notDetermined {
            Task { await ATTrackingManager.requestTrackingAuthorization() }
        }
    }
}
