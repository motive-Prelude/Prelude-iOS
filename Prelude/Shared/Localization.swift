//
//  Localization.swift
//  Prelude
//
//  Created by 송지혁 on 1/7/25.
//

import Foundation

enum Localization {
    
    enum Allergy {
        static var checkAllInstruction = String(localized: "allergy_instruction_check_all")
        static var sensitivitiesQuestion = String(localized: "allergy_question_sensitivities")
        
        static var dairyOption = String(localized: "allergy_option_dairy")
        static var eggsOption = String(localized: "allergy_option_eggs")
        static var fishOption = String(localized: "allergy_option_fish")
        static var glutenOption = String(localized: "allergy_option_gluten")
        static var peanutsOption = String(localized: "allergy_option_peanuts")
        static var shellfishOption = String(localized: "allergy_option_shellfish")
        static var soyOption = String(localized: "allergy_option_soy")
        static var treeNutsOption = String(localized: "allergy_option_tree_nuts")
        static var wheatOption = String(localized: "allergy_option_wheat")
    }
    
    enum Button {
        static var acceptContinueButtonTitle = String(localized: "button_accept_continue")
        static var buyNowButtonTitle = String(localized: "button_buy_now")
        static var cancelButtonTitle = String(localized: "button_cancel")
        static var changeButtonTitle = String(localized: "button_make_changes")
        static var checkFoodSafetyButtonTitle = String(localized: "button_check_food_safety")
        static var confirmButtonTitle = String(localized: "button_all_good")
        static var deleteButtonTitle = String(localized: "button_delete")
        static var deleteAccountButtonTitle = String(localized: "button_delete_account")
        static var getMoreButtonTitle = String(localized: "button_get_more")
        static var logOutButtonTitle = String(localized: "button_log_out")
        static var nextButtonTitle = String(localized: "button_next")
        static var receiveGiftButtonTitle = String(localized: "button_receive_gift")
        static var retryButtonTitle = String(localized: "button_retry")
        static var saveButtonTitle = String(localized: "button_save")
        static var skipButtonTitle = String(localized: "button_skip")
        
        static var beginButtonTitle = String(localized: "button_begin")
        static var enterInfoButtonTitle = String(localized: "button_enter_info")
        
    }
    
    enum BloodPressure {
        static var hyperTensionOption = String(localized: "blood_pressure_hypertension")
        static var hypoTensionOption = String(localized: "blood_pressure_hypotension")
        static var bloodPressureQuestion = String(localized: "blood_pressure_question")
        
    }
    
    enum Diabetes {
        static var type1Option = String(localized: "diabetes_type_1")
        static var type2Option = String(localized: "diabetes_type_2")
        static var gestationalOption = String(localized: "diabetes_gestational")
        static var diabetesQuestion = String(localized: "diabetes_question")
    }
    
    enum Dialog {
        static var dialogDeleteAccountTitle = String(localized: "dialog_title_delete_account")
        static var dialogDeleteAccountDescription = String(localized: "dialog_description_delete_account")
        
        static var dialogNoSeedTitle = String(localized: "dialog_title_no_seed")
        static var dialogNoSeedDescription = String(localized: "dialog_description_no_seed")
        
        static var dialogNotFoodTitle = String(localized: "dialog_title_not_food")
        static var dialogNotFoodDescription = String(localized: "dialog_description_not_food")
        
        static var dialogNetworkErrorTitle = String(localized: "dialog_title_network_error")
        static var dialogNetworkErrorDescription = String(localized: "dialog_description_network_error")
        
        static var dialogServerErrorTitle = String(localized: "dialog_title_server_error")
        static var dialogServerErrorDescription = String(localized: "dialog_description_server_error")
        
        static var dialogTimeOutTitle = String(localized: "dialog_title_time_out")
        static var dialogTimeOutDescription = String(localized: "dialog_description_time_out")
        
        static var dialogUnknownErrorTitle = String(localized: "dialog_title_unknown_error")
        static var dialogUnknownErrorDescription = String(localized: "dialog_description_unknown_error")
        
        static var dialogSkipTitle = String(localized: "dialog_title_skip")
        static var dialogSkipDescription = String(localized: "dialog_description_skip")
    }
    
    enum Error {
        static var toastAuthenticationError = String(localized: "toast_content_authentication_error")
        static var toastNetworkError = String(localized: "toast_content_network_error")
        static var toastUnknownError = String(localized: "toast_content_unknown_error")
        
        
        static var dialogUnknownErrorTitle = String(localized: "dialog_title_unknown_error")
        static var dialogUnknownErrorDescription = String(localized: "dialog_description_unknown_error")
        
        static var dialogServerErrorTitle = String(localized: "dialog_title_server_error")
        static var dialogServerErrorDescription = String(localized: "dialog_description_server_error")
        
        static var dialogNetworkErrorTitle = String(localized: "dialog_title_network_error")
        static var dialogNetworkErrorDescription = String(localized: "dialog_description_network_error")
    }
    
    enum GestationalWeek {
        static var firstTrimsterOption = String(localized: "gestation_option_1st_trimester")
        static var secondTrimsterOption = String(localized: "gestation_option_2nd_trimester")
        static var thirdTrimsterOption = String(localized: "gestation_option_3rd_trimester")
        static var postpartumOption = String(localized: "gestation_option_postpartum")
        static var postpartumDescription = String(localized: "gestation_postpartum_description")
        
        static var gestationalWeeksQuestion = String(localized: "gestation_question_weeks")
    }
    
    enum HealthInfoOption {
        static var gestationalWeek = String(localized: "health_info_option_gestational_week")
        static var bloodPressure = String(localized: "health_info_option_blood_pressure")
        static var diabetes = String(localized: "health_info_option_diabetes")
        static var heightAndWeight = String(localized: "health_info_option_height_weight")
        static var restrictions = String(localized: "health_info_option_restrictions")
    }
    
    enum NavigationHeader {
        static var navigationHeaderAccountTitle = String(localized: "navigation_title_account")
        static var navigationHeaderReportTitle = String(localized: "navigation_title_safety_report")
        static var navigationHeaderSettingTitle = String(localized: "navigation_title_settings")
        static var navigationHeaderEditHealthInfoTitle = String(localized: "navigation_title_edit_health_info")
        static var navigationHeaderGetMoreSeedsTitle = String(localized: "navigation_title_get_more_seeds")
    }
    
    enum Result {
        static func resultTitleFoodName(_ foodName: String) -> String {
            let formatString = NSLocalizedString("result_title_food", comment: "")
            return String(format: formatString, foodName)
        }
        static var positiveResultTitle = String(localized: "result_title_positive")
        static var cautionResultTitle = String(localized: "result_title_caution")
        static var negativeResultTitle = String(localized: "result_title_negative")
    }
    
    enum Label {
        static var aiWarningLabel = String(localized: "label_warning_ai")
        static var allergyTitle = String(localized: "allergy_title")
        static var basicInfoTitle = String(localized: "basic_info_title")
        static var confirmTitle = String(localized: "health_info_confirm_title")
        static var confirmSubtitle = String(localized: "health_info_confirm_subtitle")
        
        static func costWithSymbol(_ cost: String) -> String {
            let formatString = NSLocalizedString("cost_with_symbol", comment: "")
            return String(format: formatString, cost)
        }
        
        static var deleteAccountDescription = String(localized: "delete_account_description")
        
        static func paySuccessToastMessage(_ count: Int) -> String {
            let formatString = NSLocalizedString("toast_content_pay_success", comment: "")
            return String(format: formatString, count)
        }
        
        static var healthDisclaimerLabel = String(localized: "label_health_disclaimer")
        static var healthDisclaimerContent = String(localized: "health_disclaimer_content")
        static var healthDisclaimerAcceptance = String(localized: "health_disclaimer_acceptance")
        
        static var heightLabel = String(localized: "label_height")
        static var weightLabel = String(localized: "label_weight")
        
        static var inAppProductUnitLabel = String(localized: "label_seeds")
        static var weekLabel = String(localized: "label_week")
        static var remainingLabel = String(localized: "label_remaining")
        
        static var logOutDescription = String(localized: "log_out_description")
        
        static var medicalHistoryTitle = String(localized: "medical_history_title")
        static var noticeLabel = String(localized: "label_notice")
        static var noneLabel = String(localized: "label_none")
        static var noResponseLabel = String(localized: "label_no_response")
        
        static var takePhotoLabel = String(localized: "label_take_photo")
        static var privacyPolicyAcceptance = String(localized: "privacy_policy_acceptance")
        
        
        static var purchaseDescription = String(localized: "purchase_description")
        static var firstPurchaseBenefit = String(localized: "purchase_benefit_1")
        static var secondPurchaseBenefit = String(localized: "purchase_benefit_2")
        static var thirdPurchaseBenefit = String(localized: "purchase_benefit_3")
        
        static var purchaseInstruction = String(localized: "purchase_instruction")
        
        static var welcomeGiftTitle = String(localized: "welcome_gift_title")
        static var welcomeGiftContent = String(localized: "welcome_gift_content")
        
        static var firstOnboardingTitle = String(localized: "onboarding_title_1")
        static var secondOnboardingTitle = String(localized: "onboarding_title_2")
        
        static var firstOnboardingDescription = String(localized: "onboarding_description_1")
        static var secondOnboardingDescription = String(localized: "onboarding_description_2")
        
        static var seedWarningTitle = String(localized: "seed_warning_title")
        static var seedWarningSubtitle = String(localized: "seed_warning_subtitle")
        
        static var setupStartTitle = String(localized: "health_info_setup_start_title")
        static var setupStartContent = String(localized: "health_info_setup_start_content")
        
        static var appName = String(localized: "Prelude")
    }
    
    enum Loading {
        static var loadingStepImageReview = String(localized: "loading_step_review_img")
        static var loadingInstruction = String(localized: "loading_instruction")
        static var loadingStepCheckIngredient = String(localized: "loading_step_check_ingredient")
        static var loadingStepCollectDetail = String(localized: "loading_step_collect_detail")
        static var loadingTitle = String(localized: "loading_title")
    }
    
    enum PhysicalInfo {
        static var heightAndWeightQuestion = String(localized: "physical_info_question_height_weight")
    }
    
    enum Placeholder {
        static var textFieldPlaceholder = String(localized: "textfield_placeholder_food_name")
    }
    
    enum URL {
        static var healthDisclaimerAcceptanceURL = String(localized: "health_disclaimer_acceptance_URL")
        static var privacyPolicyAcceptanceURL = String(localized: "privacy_policy_acceptance_URL")
    }
}
