//
//  HealthSetUpViewModel.swift
//  Junction
//
//  Created by 송지혁 on 8/11/24.
//

import Combine
import SwiftUI

class HealthInfoSetUpViewModel: ObservableObject {
    @Published var showInstructions = true
    @Published var showInstructionText = false
    
    @Published var selectedPregnantWeek: PregnantWeek?
    @Published var selectedBloodPressure: BloodPresure?
    @Published var selectedDiabetes: Diabetes?
    
    @Published var height = ""
    @Published var weight = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func formCheck() -> Bool {
        guard selectedPregnantWeek != nil else { return true }
        guard selectedBloodPressure != nil else { return true }
        guard selectedDiabetes != nil else { return true }
        guard !height.isEmpty else { return true }
        guard !weight.isEmpty else { return true }
        return false
    }
    
    func makeHealthInfo() -> AnyPublisher<HealthInfo, Error> {
        guard let selectedPregnantWeek = selectedPregnantWeek,
              let selectedDiabetes = selectedDiabetes,
              let selectedBloodPressure = selectedBloodPressure,
              !height.isEmpty, !weight.isEmpty,
              let heightDouble = Double(height), heightDouble > 0,
              let weightDouble = Double(weight), weightDouble > 0 else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid input."])).eraseToAnyPublisher()
        }
        
        let healthInfo = HealthInfo(pregnantWeek: selectedPregnantWeek,
                                    height: height,
                                    weight: weight,
                                    bloodPressure: selectedBloodPressure,
                                    diabetes: selectedDiabetes)
        
        return Just(healthInfo)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func submit(completion: @escaping (Result<HealthInfo, Error>) -> Void) {
        makeHealthInfo()
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                }
            }, receiveValue: { healthInfo in
                completion(.success(healthInfo))
            })
            .store(in: &cancellables)
    }
    
    func animateInstructionText(after delay: TimeInterval = 0.6, duration: Double = 0.4, bounce: Double = 0.5, blendDuration: Double = 0.2) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(duration: duration, bounce: bounce, blendDuration: blendDuration)) {
                self.showInstructionText = true
                self.pagenation()
            }
        }
    }
    
    private func pagenation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.linear(duration: 0.3)) {
                self.showInstructions = false
            }
        }
    }
}
