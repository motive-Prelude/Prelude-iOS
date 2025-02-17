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
    
    func generatePrompt(with healthInfo: HealthInfo?) -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        
        return """
            "prompt": [
                "intro": "다음은 임산부 사용자의 건강 정보야",
                "healthInfo": [
                    "pregnantWeek": \(healthInfo?.gestationalWeek.localized ?? "No response"),
                    "bmi": \(healthInfo?.bmi ?? 0.0),
                    "bloodPressure": \(healthInfo?.bloodPressure.localized ?? "No response"),
                    "diabetes": \(healthInfo?.diabetes.localized ?? "No response"),
                    "restrictions": \(healthInfo?.restrictions.map { String($0.rawValue) }.joined(separator: ", ") ?? ""),
                    "local": \(languageCode),
                ]
            ]
        """
    }
    
    func generateHealthPrompt(with healthInfo: HealthInfo?) -> String {
        guard let healthInfo else { return "" }
        
        return """
                Information about the pregnant woman's health:
                - Gestational week: \(healthInfo.gestationalWeek.rawValue)
                - BMI: \(healthInfo.bmi)
                - Blood pressure: \(healthInfo.bloodPressure.rawValue)
                - History of diabetes: \(healthInfo.diabetes.rawValue)
                - Allergies: \(healthInfo.restrictions.map { String($0.rawValue) }.joined(separator: ", "))
                """
    }
    
    func generateFoodNutritionPrompt(with foodNutrition: FoodNutritionResponse) -> String {
        return """
                Food Nutrition Information:
                \(foodNutrition.nutritionInfo.map {
                    "- \($0.nutrient): \($0.value)"
                }.joined(separator: "\n"))
                """
    }
    
    func generateFindingFoodNamePrompt() -> String {
            """
            1. Analyze the provided food photo and use Google search to identify the exact name and quantity of the food. Provide a detailed explanation of the basis for your analysis.
            2. If the food product includes a brand label, find a product on Google search that matches the food photo or packaging as closely as possible and analyze it.
            3. If there are multiple foods in the photo, describe only the one with the highest recognition accuracy.
            4. All answers must be provided based on Google search results.
            """
    }
    
    func generateFindingFoodNutritionPrompt() -> String {
            """
            1. Must Perform a 'google grounding mode'(real time google web search) to find the exact nutritional information of the described food. Finding the product's Nutrition Facts label is the most accurate approach.
            2. If you find the product's Nutrition Facts label, recognize all possible values listed on the label.
            3. For foods whose nutritional content varies depending on additional ingredients or quantities, provide the average nutritional values.
            4. Instead of results like "varies depending on the amount of soy sauce," present quantitative data such as "15g (average serving size)."
            """
    }
    
    func generateMedicalInformationPrompt(healthInfo: HealthInfo?) -> String {
        let healthInfoPrompt = PromptGenerator.shared.generateHealthPrompt(with: healthInfo)
        
        return """
        1. For each nutrient in the food, evaluate how it relates to the health status and recommended guidelines for pregnant women. Compare the nutrient's quantity to the recommended daily intake based on the pregnant woman's current condition, and assess its impact on their health.
        2. When making medical judgments, follow these criteria:
        * Must Perform a 'google grounding mode'(real time google web search) to access the most up-to-date research, guidelines and studies.
        * Information from credible and reliable institutions (e.g., ACOG, WHO, FDA, Ministry of Food and Drug Safety)
        * Medical research papers published within the last 5 years (e.g., PubMed, Web of Science)
        
        
        \(healthInfoPrompt)
        """
    }
    
    func generateJSONPostProcessingPrompt() -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return """
            1. Translate the response **strictly** according to the provided `languageCode`. The entire response must be translated without leaving out any content. If the translation does not match the specified language, the response will be considered invalid.
        * If `languageCode` is 'ko', translate **all content** into Korean naturally and conversationally, avoiding overly formal or literal translation styles. Use everyday Korean expressions to ensure clarity and relatability.
        2. Only provide the translated version in JSON format. Do not include the original English version or any additional explanations.
        3. Organize the provided content into the JSON format specified below. Only include the fields specified in the format, and do not add any additional fields.
        4. Start directly with the main content (the diagnosis of whether the food is safe for pregnant women). Do not include introductions or unnecessary context.
        5. For the `is_safe` field in the JSON, provide one of the following values based on medical judgment: "positive," "caution," or "negative."
        
        **Important:** If the response is not fully translated into the specified language (`languageCode`), or if any part of the content is omitted, it will be considered incomplete and invalid.
        
        Language Code: \(languageCode)
        
        JSON Format:
        {
        "food": "Food name",
        "is_safe": "caution",
        "nutrition": [
        {
            "nutrient": "Nutrient name",
            "value": "Nutrient value(specific numbers)",
            "description": "Impact of the nutrient on pregnant women's health based on medical evidence"
        }
        ]
        }
        """
    }
}
