//
//  PromptGenerator.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Foundation

class PromptGenerator {
    static let shared = PromptGenerator()
    private(set) var greetingPrompt: String
    
    
    
    init() {
        self.greetingPrompt = Self.generateGreetingPrompt()
    }
    
    static func generateGreetingPrompt() -> String {
        let greetingTitle1 = String(localized: "main_greeting_title_1")
        let greetingTitle2 = String(localized: "main_greeting_title_2")
        let greetingTitle3 = String(localized: "main_greeting_title_3")
        let greetingTitle4 = String(localized: "main_greeting_title_4")
        let greetingTitle5 = String(localized: "main_greeting_title_5")
        let greetingTitle6 = String(localized: "main_greeting_title_6")
        let greetingTitle7 = String(localized: "main_greeting_title_7")
        
        return [greetingTitle1, greetingTitle2, greetingTitle3, greetingTitle4, greetingTitle5, greetingTitle6, greetingTitle7]
            .randomElement() ?? greetingTitle1
    }
    
    func generatePrompt(with healthInfo: HealthInfo) -> String {
        return """
            "prompt": [
                "intro": "다음은 임산부 사용자의 건강 정보야",
                "healthInfo": [
                    "pregnantWeek": \(healthInfo.gestationalWeek.rawValue),
                    "bmi": \(healthInfo.bmi),
                    "bloodPressure": \(healthInfo.bloodPressure.rawValue),
                    "diabetes": \(healthInfo.diabetes.rawValue)
                ],
                "instruction": "다음에 올 사용자의 질문에 instruction 내용을 바탕으로 성실히 답변해줘!",
                "note": "음식이 여러 개일 경우 가장 식별 신뢰도가 높은 하나의 음식을 선정해서 그 음식만 평가해줘!"
            ]
        """
    }
}
