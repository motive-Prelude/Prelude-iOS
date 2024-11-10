//
//  AssistantInteractionFacadeImpl.swift
//  bottari
//
//  Created by 송지혁 on 7/31/24.
//

import UIKit

class AssistantInteractionFacadeImpl: AssistantInteractionFacade {
    
    private let createThreadAndRunUseCase: CreateThreadAndRunUseCase
    private let listRunStepUseCase: ListRunStepUseCase
    private let retrieveMessageUseCase: RetrieveMessageUseCase
    private let uploadImageUseCase: UploadImageUseCase
    
    private var assistantID: String {
        guard let assistantID = Bundle.main.object(forInfoDictionaryKey: "ASSISTANT_ID") as? String else { return "" }
        return assistantID
    }
    
    @Published var errorMessage: String?
    
    init(createThreadAndRunUseCase: CreateThreadAndRunUseCase,
         listRunStepUseCase: ListRunStepUseCase,
        retrieveMessageUseCase: RetrieveMessageUseCase,
         uploadImageUseCase: UploadImageUseCase) {
        self.createThreadAndRunUseCase = createThreadAndRunUseCase
        self.listRunStepUseCase = listRunStepUseCase
        self.retrieveMessageUseCase = retrieveMessageUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    public func interact(with message: String, image: UIImage?) async throws -> Judgement {
        
        var fileID: String = ""
        
        do {
            if let image { fileID = try await uploadImageUseCase.execute(image).id }
            let runResponse = try await createThreadAndRunUseCase.execute(assistantID: assistantID, messages: [message], fileID: fileID)
            let threadID = runResponse.threadID
            let runID = runResponse.runID
            
            let messageID = try await waitForMessageID(threadID: threadID, runID: runID)
            
            let message = try await waitForMessage(threadID: threadID, messageID: messageID)
            guard let data = message.data(using: .utf8) else { fatalError("encoding 안됌") }
            
            let judgement = try JSONDecoder().decode(Judgement.self, from: data)
            
            return judgement
        } catch {
            print(error)
            throw error
        }
    }
    
    private func waitForMessageID(threadID: String, runID: String, maxAttempts: Int = 10, delayInSeconds: TimeInterval = 1.0) async throws -> String {
        var attempts = 0
        
        while attempts < maxAttempts {
            let runStepResponse = try await listRunStepUseCase.execute(threadID: threadID, runID: runID)
            
            if let messageID = runStepResponse.data.first?.stepDetails.messageCreation?.messageId {
                return messageID
            } else {
                attempts += 1
                print("MessageID is not ready. Retrying... (\(attempts))")
                try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
            }
        }
        
        throw MessagePollingError.timeout
    }
    
    private func waitForMessage(threadID: String, messageID: String, maxAttempts: Int = 10, delayInSeconds: TimeInterval = 1.0) async throws -> String {
        var attempts = 0
        
        while attempts < maxAttempts {
            let retrieveMessageResponse = try await retrieveMessageUseCase.execute(threadID: threadID, messageID: messageID)
            
            if let message = retrieveMessageResponse.content.first?.text.value { return message }
            else {
                attempts += 1
                print("Message is not ready. Retrying... (\(attempts))")
                try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
            }
        }
        
        throw MessagePollingError.timeout
    }
}

enum MessagePollingError: Error {
    case timeout
}
