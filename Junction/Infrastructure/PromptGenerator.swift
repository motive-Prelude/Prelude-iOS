//
//  PromptGenerator.swift
//  Junction
//
//  Created by 송지혁 on 11/10/24.
//

import Foundation

class PromptGenerator {
    func generatePrompt(with healthInfo: HealthInfo) -> String {
        return """
            "prompt": [
                "intro": "다음은 임산부 사용자의 건강 정보야",
                "healthInfo": [
                    "pregnantWeek": \(healthInfo.pregnantWeek.rawValue),
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
