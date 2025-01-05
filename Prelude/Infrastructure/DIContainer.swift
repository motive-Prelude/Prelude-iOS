//
//  DIContainer.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Foundation
import CoreML

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    private init() {
        setupDependencies()
    }
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = String(reflecting: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(reflecting: type)
        return dependencies[key] as? T
    }
    
    private func setupDependencies() {
        register(APIClient.self, dependency: APIClient())
        register(FirebaseAuthDataSource.self, dependency: FirebaseAuthDataSource())
        register(SwiftDataSource.self, dependency: SwiftDataSource.shared)
        register(ICloudDataSource.self, dependency: ICloudDataSource.shared)
        register(FirestoreDataSource<UserInfo>.self, dependency: FirestoreDataSource<UserInfo>())
        
        // Repositories
        register(ThreadRepository.self, dependency: ThreadRepositoryImpl(apiService: resolve(APIClient.self)!))
        register(MessageRepository.self, dependency: MessageRepositoryImpl(apiService: resolve(APIClient.self)!))
        register(RunRepository.self, dependency: RunRepositoryImpl(apiService: resolve(APIClient.self)!))
        register(RunStepRepository.self, dependency: RunStepRepositoryImpl(apiService: resolve(APIClient.self)!))
        register(CreateThreadAndRunRepository.self, dependency: CreateThreadAndRunRepositoryImpl(apiClient: resolve(APIClient.self)!))
        register(OCRRepository.self, dependency: OCRRepositoryImpl())
        register(TextPredictionRepository.self, dependency: TextPredictionRepositoryImpl(model: try! FoodTextDetection(configuration: MLModelConfiguration())))
        register(AuthRepository.self, dependency: AuthRepositoryImpl(dataSource: resolve(FirebaseAuthDataSource.self)!))
        register(UserRepository.self, dependency: UserRepository(
            swiftDataSource: resolve(SwiftDataSource.self)!,
            iCloudDataSource: resolve(ICloudDataSource.self)!,
            firestoreDataSource: resolve(FirestoreDataSource<UserInfo>.self)!))
        
        // ImageRepository 등록
        register(ImageRepository.self, dependency:  ImageRepositoryImpl(apiClient: resolve(APIClient.self)!))
        
        // Use Cases
        register(CreateThreadUseCase.self, dependency: CreateThreadUseCase(repository: resolve(ThreadRepository.self)!))
        register(CreateMessageUseCase.self, dependency: CreateMessageUseCase(repository: resolve(MessageRepository.self)!))
        register(CreateRunUseCase.self, dependency: CreateRunUseCase(repository: resolve(RunRepository.self)!))
        register(ListRunStepUseCase.self, dependency: ListRunStepUseCase(repository: resolve(RunStepRepository.self)!))
        register(RetrieveMessageUseCase.self, dependency: RetrieveMessageUseCase(repository: resolve(MessageRepository.self)!))
        register(CreateThreadAndRunUseCase.self, dependency: CreateThreadAndRunUseCase(repository: resolve(CreateThreadAndRunRepository.self)!))
        register(PerformOCRUseCase.self, dependency: PerformOCRUseCase(ocrRepository: resolve(OCRRepository.self)!))
        register(PredictFoodTextUseCase.self, dependency: PredictFoodTextUseCase(repository: resolve(TextPredictionRepository.self)!))
        register(ImageClassifierUseCase.self, dependency: ImageClassifierUseCase())
        register(LoginUseCase.self, dependency: LoginUseCase(authRepository: resolve(AuthRepository.self)!))
        register(LogOutUseCase.self, dependency: LogOutUseCase(authRepository: resolve(AuthRepository.self)!))
        register(DeleteAccountUseCase.self, dependency: DeleteAccountUseCase(authRepository: resolve(AuthRepository.self)!))
        register(ObserveAuthStateUseCase.self, dependency: ObserveAuthStateUseCase(authRepository: resolve(AuthRepository.self)!))
        register(ReauthenticateUseCase.self, dependency: ReauthenticateUseCase(authRepository: resolve(AuthRepository.self)!))
        // UploadImageUseCase 등록
        register(UploadImageUseCase.self, dependency: UploadImageUseCase(repository: resolve(ImageRepository.self)!))
    }
}
