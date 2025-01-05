//
//  AlertManager.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Combine
import SwiftUI

struct AlertAction: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var isAlertVisible = false
    @Published var isToastVisible = false
    
    @Published var toastIcon: Image?
    @Published var toastDescription = ""
    @Published var title = ""
    @Published var message = ""
    @Published var actions: [AlertAction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var toastAnimation: Animation { .bouncy(duration: 0.4, extraBounce: 0.1) }
    
    private init() {
        EventBus.shared.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(error)
            }
            .store(in: &cancellables)
        
        EventBus.shared.toastPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.showToast(event)
            }
            .store(in: &cancellables)
    }
    
    func showAlert(title: String, message: String, actions: [AlertAction]) {
        self.title = title
        self.message = message
        self.actions = actions
        isAlertVisible = true
    }
    
    func showToast(_ event: ToastEvent) {
        guard !isToastVisible else { return }
        self.toastIcon = Image(.checkSmall)
        self.toastDescription = makeToastDescription(event)
        withAnimation(toastAnimation) {
            isToastVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(self.toastAnimation) {
                self.isToastVisible = false
            }
        }
    }
    
    func showToast(_ error: DomainError) {
        guard !isToastVisible else { return }
        self.toastIcon = Image(.checkSmall)
        self.toastDescription = makeToastDescription(error)
        withAnimation(toastAnimation) {
            isToastVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(self.toastAnimation) {
                self.isToastVisible = false
            }
        }
    }
    
    private func makeToastDescription(_ error: DomainError) -> String {
        switch error {
            case .authenticationFailed(reason: let reason): reason
            case .networkUnavailable: "Network Error"
            case .serverError: "Server BulAnJeoung"
            case .timeout: "요청 시간 ㅈㄴ 김 다시 시도"
            case .tooManyRequests: "너무 많은 시도입니다 나중에 ㄱ"
            case .unknown: "Message"
        }
    }
    
    private func makeToastDescription(_ event: ToastEvent) -> String {
        switch event {
            case .paymentCompleted(let count): "Successfully added \(count) seeds!"
        }
    }
    
    func hideAlert() { isAlertVisible = false }
}
