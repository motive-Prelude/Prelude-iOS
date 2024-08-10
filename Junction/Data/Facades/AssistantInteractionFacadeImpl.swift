//
//  AssistantInteractionFacadeImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import Combine
import Foundation

enum AssistantInteractionError: Error {
    case emptyRunStepResponse
    case operationTimedOut
}

class AssistantInteractionFacadeImpl: AssistantInteractionFacade {
    
    private let createThreadUseCase: CreateThreadUseCase
    private let createMessageUseCase: CreateMessageUseCase
    private let createRunUseCase: CreateRunUseCase
    private let listRunStepUseCase: ListRunStepUseCase
    private let retrieveMessageUseCase: RetrieveMessageUseCase
    
    private var assistantID: String {
        guard let assistantID = Bundle.main.object(forInfoDictionaryKey: "ASSISTANT_ID") as? String else { return "" }
        return assistantID
    }
    
    @Published var threadResponse: ThreadResponse?
    @Published var messageResponse: CreateMessageResponse?
    @Published var runResponse: RunResponse?
    @Published var runStepResponse: RunStepResponse?
    @Published var retrieveMessageResponse: RetrieveMessageResponse?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(createThreadUseCase: CreateThreadUseCase,
         createMessageUseCase: CreateMessageUseCase,
         createRunUseCase: CreateRunUseCase,
         listRunStepUseCase: ListRunStepUseCase,
         retrieveMessageUseCase: RetrieveMessageUseCase) {
        self.createThreadUseCase = createThreadUseCase
        self.createMessageUseCase = createMessageUseCase
        self.createRunUseCase = createRunUseCase
        self.listRunStepUseCase = listRunStepUseCase
        self.retrieveMessageUseCase = retrieveMessageUseCase
    }
    
    public func interact(with message: String) -> AnyPublisher<String, Error> {
        return createThread(messages: [message])
            .flatMap { [weak self] threadResponse in
                self?.createMessageAndRun(threadResponse: threadResponse, message: message) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .flatMap { [weak self] runResponse in
                self?.listRunStepAndRetrieveMessage(runResponse: runResponse) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func createThread(messages: [String]) -> AnyPublisher<ThreadResponse, Error> {
        createThreadUseCase.execute(messages: messages)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.threadResponse = response
            })
            .eraseToAnyPublisher()
    }
    
    private func createMessageAndRun(threadResponse: ThreadResponse, message: String) -> AnyPublisher<RunResponse, Error> {
        return createMessage(threadID: threadResponse.id, message: message)
            .flatMap { [weak self] messageResponse in
                self?.createRun(threadID: messageResponse.threadId) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func createMessage(threadID: String, message: String) -> AnyPublisher<CreateMessageResponse, Error> {
        createMessageUseCase.execute(threadID: threadID, message: message)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.messageResponse = response
            })
            .eraseToAnyPublisher()
    }
    
    private func createRun(threadID: String) -> AnyPublisher<RunResponse, Error> {
        createRunUseCase.execute(threadID: threadID, assistantID: assistantID)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.runResponse = response
            })
            .eraseToAnyPublisher()
    }
    
    private func listRunStepAndRetrieveMessage(runResponse: RunResponse) -> AnyPublisher<String, Error> {
        return listRunStep(threadID: threadResponse?.id ?? "", runID: runResponse.id)
            .flatMap { [weak self] runStepResponse in
                self?.retrieveMessage(runStepResponse: runStepResponse) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func listRunStep(threadID: String, runID: String) -> AnyPublisher<RunStepResponse, Error> {
        listRunStepUseCase.execute(threadID: threadID, runID: runID)
            .tryMap { response in
                guard !response.data.isEmpty else {
                    throw AssistantInteractionError.emptyRunStepResponse
                }
                return response
            }
            .retry(100)
            .timeout(40, scheduler: DispatchQueue.main, customError: { NSError(domain: "AssistantInteractionFacade", code: 2, userInfo: [NSLocalizedDescriptionKey: "Operation timed out"]) })
            .handleEvents(receiveOutput: { [weak self] response in
                self?.runStepResponse = response
            })
            .eraseToAnyPublisher()
    }
    
    private func retrieveMessage(runStepResponse: RunStepResponse) -> AnyPublisher<String, Error> {
        guard let lastMessageID = runStepResponse.data.first?.stepDetails.messageCreation?.messageId else {
            return Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "No message found in run step"])).eraseToAnyPublisher()
        }
        
        return retrieveMessageUseCase.execute(threadID: threadResponse?.id ?? "", messageID: lastMessageID)
            .tryMap { response in
                guard !response.content.isEmpty else {
                    throw AssistantInteractionError.emptyRunStepResponse
                }
                return response
            }
            .retry(100)
            .timeout(40, scheduler: DispatchQueue.main, customError: { NSError(domain: "AssistantInteractionFacade", code: 2, userInfo: [NSLocalizedDescriptionKey: "Operation timed out"]) })
            .handleEvents(receiveOutput: { [weak self] response in
                self?.retrieveMessageResponse = response
                print(response)
            })
            .map { retrieveMessageResponse in
                retrieveMessageResponse.content.first?.text.value ?? ""
            }
            .eraseToAnyPublisher()
    }
}
