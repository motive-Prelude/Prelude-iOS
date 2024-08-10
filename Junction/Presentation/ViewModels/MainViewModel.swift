//
//  MainViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import Foundation

class MainViewModel: ObservableObject {
    private let assistantInteractionFacade: AssistantInteractionFacadeImpl
    private var cancellables = Set<AnyCancellable>()
    @Published var receivedMessage: String?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl(
        createThreadUseCase: DIContainer.shared.resolve(CreateThreadUseCase.self)!,
        createMessageUseCase: DIContainer.shared.resolve(CreateMessageUseCase.self)!,
        createRunUseCase: DIContainer.shared.resolve(CreateRunUseCase.self)!,
        listRunStepUseCase: DIContainer.shared.resolve(ListRunStepUseCase.self)!,
        retrieveMessageUseCase: DIContainer.shared.resolve(RetrieveMessageUseCase.self)!)) {
        self.assistantInteractionFacade = assistantInteractionFacade
    }
    
    func sendMessageForQuiz(_ message: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.assistantInteractionFacade.interact(with: message)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error)
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }, receiveValue: { response in
                    print(response)
                    self.receivedMessage = response
                })
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}
