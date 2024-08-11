//
//  AssistantInteractionFacadeImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import Combine
import UIKit

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
    private let uploadImageUseCase: UploadImageUseCase
    
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
         retrieveMessageUseCase: RetrieveMessageUseCase,
         uploadImageUseCase: UploadImageUseCase) {
        self.createThreadUseCase = createThreadUseCase
        self.createMessageUseCase = createMessageUseCase
        self.createRunUseCase = createRunUseCase
        self.listRunStepUseCase = listRunStepUseCase
        self.retrieveMessageUseCase = retrieveMessageUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    public func interact(with message: String, image: UIImage?) -> AnyPublisher<Judgement, Error> {
        var capturedFileId: String? = nil
        
        let fileIdPublisher: AnyPublisher<String?, Error> = {
            if let image = image {
                return uploadImageUseCase.execute(image)
                    .map { $0.id }
                    .retry(100)
                    .eraseToAnyPublisher()
            } else {
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }()
        
        return fileIdPublisher
            .flatMap { [weak self] fileId in
                if capturedFileId == nil {
                    capturedFileId = fileId
                }
                
                return self?.createThread(messages: [message], fileId: fileId) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .flatMap { [weak self] threadResponse in
                return self?.createMessageAndRun(threadResponse: threadResponse, text: message, fileId: capturedFileId) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .flatMap { [weak self] runResponse in
                self?.listRunStepAndRetrieveMessage(runResponse: runResponse) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
            }
            .tryMap { responseString in
                guard let data = responseString.data(using: .utf8) else {
                    throw NSError(domain: "AssistantInteractionFacade", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert String to Data"])
                }
                return try JSONDecoder().decode(Judgement.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    
    
    private func createThread(messages: [String], fileId: String?) -> AnyPublisher<ThreadResponse, Error> {
        return createThreadUseCase.execute(messages: messages, fileId: fileId)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.threadResponse = response
            })
            .eraseToAnyPublisher()
    }
    
    private func createMessageAndRun(threadResponse: ThreadResponse, text: String?, fileId: String?) -> AnyPublisher<RunResponse, Error> {
        return createRun(threadID: threadResponse.id).eraseToAnyPublisher()
        
//        return createMessage(threadID: threadResponse.id, text: text, fileId: fileId)
//            .flatMap { [weak self] messageResponse in
//                self?.createRun(threadID: messageResponse.threadId) ?? Fail(error: NSError(domain: "AssistantInteractionFacade", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
    }
    
    private func createMessage(threadID: String, text: String?, fileId: String?) -> AnyPublisher<CreateMessageResponse, Error> {
        createMessageUseCase.execute(threadID: threadID, text: text, fileId: fileId)
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
