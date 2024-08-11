//
//  DIContainer.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import Foundation

final class DIContainer: ObservableObject {
    static let shared = DIContainer()
    
    private init() {
        setupDependencies()
    }
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
    
    private func setupDependencies() {
        register(APIService.self, dependency: APIService())
        
        // Repositories
        register(ThreadRepository.self, dependency: ThreadRepositoryImpl(apiService: resolve(APIService.self)!))
        register(MessageRepository.self, dependency: MessageRepositoryImpl(apiService: resolve(APIService.self)!))
        register(RunRepository.self, dependency: RunRepositoryImpl(apiService: resolve(APIService.self)!))
        register(RunStepRepository.self, dependency: RunStepRepositoryImpl(apiService: resolve(APIService.self)!))
        
        // ImageRepository 등록
        register(ImageRepository.self, dependency: ImageRepositoryImpl(apiService: resolve(APIService.self)!))
        
        // Use Cases
        register(CreateThreadUseCase.self, dependency: CreateThreadUseCase(repository: resolve(ThreadRepository.self)!))
        register(CreateMessageUseCase.self, dependency: CreateMessageUseCase(repository: resolve(MessageRepository.self)!))
        register(CreateRunUseCase.self, dependency: CreateRunUseCase(repository: resolve(RunRepository.self)!))
        register(ListRunStepUseCase.self, dependency: ListRunStepUseCase(repository: resolve(RunStepRepository.self)!))
        register(RetrieveMessageUseCase.self, dependency: RetrieveMessageUseCase(repository: resolve(MessageRepository.self)!))
        
        // UploadImageUseCase 등록
        register(UploadImageUseCase.self, dependency: UploadImageUseCase(repository: resolve(ImageRepository.self)!))
    }
}
