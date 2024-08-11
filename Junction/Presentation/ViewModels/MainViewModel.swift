//
//  MainViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Combine
import UIKit

class MainViewModel: ObservableObject {
    private let assistantInteractionFacade: AssistantInteractionFacadeImpl
    
    private var cancellables = Set<AnyCancellable>()
    @Published var receivedMessage: String?
    @Published var imageErrorMessage: String?
    @Published var userHealthInfo: HealthInfo?
    
    @Published var prompt = ""
    @Published var judgement: Judgement?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl(
        createThreadUseCase: DIContainer.shared.resolve(CreateThreadUseCase.self)!,
        createMessageUseCase: DIContainer.shared.resolve(CreateMessageUseCase.self)!,
        createRunUseCase: DIContainer.shared.resolve(CreateRunUseCase.self)!,
        listRunStepUseCase: DIContainer.shared.resolve(ListRunStepUseCase.self)!,
        retrieveMessageUseCase: DIContainer.shared.resolve(RetrieveMessageUseCase.self)!,
        uploadImageUseCase: DIContainer.shared.resolve(UploadImageUseCase.self)!
    )) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
        self.loadHealthInfo()
        
        $userHealthInfo
            .sink { healthInfo in
                guard let healthInfo = healthInfo else { return }
                self.prompt = """
                    다음은 임산부 사용자의 건강 정보야
                    \(healthInfo.pregnantWeek.rawValue)이고, bmi 지수는 \(healthInfo.bmi)야.
                    혈압은 \(healthInfo.bloodPressure.rawValue). \(healthInfo.diabetes.rawValue).
                    다음에 올 사용자의 질문에 instruction 내용을 바탕으로 성실히 답변해줘!\n
                    

                    """
            }
    }
    
//    func uploadImage(image: UIImage) {
//        return uploadImageUseCase.execute(image)
//            .handleEvents(receiveOutput: { fileResponse in
//                self.receivedMessage = "Uploaded file: \(fileResponse.filename) with ID: \(fileResponse.id)"
//            }, receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    print("Image upload failed with error: \(error)")
//                    self.imageErrorMessage = "Image upload failed with"
//                }
//            })
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                    case .failure(let error):
//                        print("Upload failed with error: \(error)")
//                        self.imageErrorMessage = "Upload failed with \(error)"
//                        
//                    case .finished:
//                        print("Upload finished successfully.")
//                        self.imageErrorMessage = "Upload finished successfully."
//                }
//            }, receiveValue: { fileResponse in
//                print("File ID: \(fileResponse.id)")
//                print("Filename: \(fileResponse.filename)")
//            })
//            .store(in: &cancellables)
//    }
    
    func sendMessage(_ message: String, image: UIImage?) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.assistantInteractionFacade.interact(with: self.prompt + message, image: image)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error)
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }, receiveValue: { response in
                    print(response)
                    self.judgement = response
                })
                .store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
    
    func loadHealthInfo() {
        if let data = UserDefaults.standard.data(forKey: "HealthInfo") {
            let decoder = JSONDecoder()
            if let healthInfo = try? decoder.decode(HealthInfo.self, from: data) {
                self.userHealthInfo = healthInfo
            }
        }
    }
}
