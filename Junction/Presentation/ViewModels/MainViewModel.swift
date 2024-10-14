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
    private let cloudkitManager: CloudKitManager
    private let swiftDataManager: SwiftDataManager
    @Published var receivedMessage: String?
    @Published var imageErrorMessage: String?
    @Published var healthInfo: HealthInfo?
    @Published var userInfo: UserInfo?
    
    @Published var prompt = ""
    @Published var judgement: Judgement?
    
    init(assistantInteractionFacade: AssistantInteractionFacadeImpl = AssistantInteractionFacadeImpl(
        createThreadUseCase: DIContainer.shared.resolve(CreateThreadUseCase.self)!,
        createMessageUseCase: DIContainer.shared.resolve(CreateMessageUseCase.self)!,
        createRunUseCase: DIContainer.shared.resolve(CreateRunUseCase.self)!,
        listRunStepUseCase: DIContainer.shared.resolve(ListRunStepUseCase.self)!,
        retrieveMessageUseCase: DIContainer.shared.resolve(RetrieveMessageUseCase.self)!,
        uploadImageUseCase: DIContainer.shared.resolve(UploadImageUseCase.self)!
    ), swiftDataManager: SwiftDataManager = SwiftDataManager.shared, cloudKitManager: CloudKitManager = CloudKitManager.shared) {
        
        self.assistantInteractionFacade = assistantInteractionFacade
        self.swiftDataManager = swiftDataManager
        self.cloudkitManager = cloudKitManager
        
        $userInfo
            .sink { userInfo in
                self.objectWillChange.send()
                self.healthInfo = userInfo?.healthInfo
                
                
            }
            .store(in: &cancellables)
        
        $healthInfo
            .sink { healthInfo in
                guard let healthInfo = healthInfo else { return }
                self.prompt = """
                    다음은 임산부 사용자의 건강 정보야
                    \(healthInfo.pregnantWeek.rawValue)이고, bmi 지수는 \(healthInfo.bmi)야.
                    혈압은 \(healthInfo.bloodPressure.rawValue). \(healthInfo.diabetes.rawValue).
                    다음에 올 사용자의 질문에 instruction 내용을 바탕으로 성실히 답변해줘!\n
                    
                    
                    """
            }
            .store(in: &cancellables)
        
        cloudKitManager.cloudKitNotificationSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task {
                    guard let record = await self.cloudkitManager.fetch(recordString: "UserInfo") else { return }
                    
                    await MainActor.run {
                        guard let healthInfo = self.healthInfo, let newUserInfo = UserInfo(from: record, healthInfo: healthInfo) else { return }
                        self.objectWillChange.send()
                        self.userInfo = newUserInfo
                        
                        print(self.userInfo?.remainingTimes ?? "No remaining times")
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    func fetchUserInfo() { self.userInfo = swiftDataManager.fetchLatest(data: UserInfo.self) }
    
    
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
    
    func submit() async {
        userInfo?.remainingTimes -= 1
        guard let userInfoRecord = userInfo?.toCKRecord() else { return }
        await cloudkitManager.update(record: userInfoRecord, type: UserInfo.self)
        
        guard let record = await cloudkitManager.fetch(recordString: "UserInfo") else { return }
        guard let healthInfo = healthInfo, let newUserInfo = UserInfo(from: record, healthInfo: healthInfo) else { return }
        
        await MainActor.run { self.userInfo = newUserInfo }
        swiftDataManager.saveData(newUserInfo)
    }
    
}
