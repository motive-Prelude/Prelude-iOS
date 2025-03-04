# Prelude - iOS


###  Author

|<img src="https://avatars.githubusercontent.com/u/114010099?v=4" width="150" height="150"/>|<img src="https://avatars.githubusercontent.com/u/126383419?v=4" width="150" height="150"/>|
|:-:|:-:|
|**iOS Developer**<br/>송지혁<br/>[00306](https://github.com/00306)|**Product Designer**<br/>박민교<br/>[SONIA](https://github.com/sonia-nines)|


<br />


### 🛠️ Development Environment
<div>
<img src="https://img.shields.io/badge/17+-555555?style=for-the-badge&logo=ios&logoColor=white">
<img src="https://img.shields.io/badge/Swift 5.7-F05138?style=for-the-badge&logo=swift&logoColor=white">
<img src="https://img.shields.io/badge/Xcode-147EFB?style=for-the-badge&logo=Xcode&logoColor=white">
<img src="https://img.shields.io/badge/SPM-000000?style=for-the-badge&logo=swift&logoColor=white">
  
</div>


<br />



### ✨ Tech Stack
* SwiftUI
* Swift Concurrency
* SwiftData
* CloudKit
* REST API


<br />


### 🏛️ Architecture

 **MVVM + Clean Architecture**

![CleanArchitecture](https://github.com/user-attachments/assets/01158f28-f8c4-4128-a386-5f3c6d781d4d)


<br />


### 🗂️ Folder Structure

```
📦Prelude
 ┣ 📂Data
 ┃ ┣ 📂API
 ┃ ┃ ┣ 📂EndPoints
 ┃ ┃ ┃ ┣ 📜GeminiEndPoint.swift
 ┃ ┃ ┃ ┣ 📜OpenAIEndPoint.swift
 ┃ ┃ ┃ ┗ 📜PerplexityEndPoint.swift
 ┃ ┃ ┣ 📂Protocols
 ┃ ┃ ┃ ┣ 📜APIRequest.swift
 ┃ ┃ ┃ ┗ 📜Endpoint.swift
 ┃ ┃ ┣ 📂Requests
 ┃ ┃ ┃ ┣ 📜GeminiRequest.swift
 ┃ ┃ ┃ ┗ 📜PerplexityRequest.swift
 ┃ ┃ ┣ 📂Responses
 ┃ ┃ ┃ ┗ 📜PerplexityResponse.swift
 ┃ ┃ ┗ 📜APIClient.swift
 ┃ ┣ 📂DataSources
 ┃ ┃ ┣ 📜FirebaseAuthDataSource.swift
 ┃ ┃ ┣ 📜FirestoreDataSource.swift
 ┃ ┃ ┣ 📜ICloudDataSource.swift
 ┃ ┃ ┗ 📜SwiftDataSource.swift
 ┃ ┣ 📂Errors
 ┃ ┃ ┣ 📜APIError.swift
 ┃ ┃ ┣ 📜AuthError.swift
 ┃ ┃ ┣ 📜DataSourceError.swift
 ┃ ┃ ┗ 📜RepositoryError.swift
 ┃ ┣ 📂Facades
 ┃ ┃ ┗ 📜AssistantInteractionFacadeImpl.swift
 ┃ ┣ 📂Repositories
 ┃ ┃ ┣ 📜AuthRepositoryImpl.swift
 ┃ ┃ ┣ 📜CreateThreadAndRunRepositoryImpl.swift
 ┃ ┃ ┣ 📜GeminiChatRepository.swift
 ┃ ┃ ┣ 📜ImageRepositoryImpl.swift
 ┃ ┃ ┣ 📜MessageRepositoryImpl.swift
 ┃ ┃ ┣ 📜OCRRepositoryImpl.swift
 ┃ ┃ ┣ 📜PerplexityChatRepository.swift
 ┃ ┃ ┣ 📜RunRepositoryImpl.swift
 ┃ ┃ ┣ 📜RunStepRepositoryImpl.swift
 ┃ ┃ ┣ 📜TextPredictionRepositoryImpl.swift
 ┃ ┃ ┣ 📜ThreadRepositoryImpl.swift
 ┃ ┃ ┗ 📜UserRepository.swift
 ┃ ┣ 📜.DS_Store
 ┃ ┗ 📜AuthCredentialMapper.swift
 ┣ 📂Domain
 ┃ ┣ 📂Entities
 ┃ ┃ ┣ 📂Assistant
 ┃ ┃ ┃ ┣ 📂FoodName
 ┃ ┃ ┃ ┃ ┣ 📜FoodNameAssistantResponse.swift
 ┃ ┃ ┃ ┃ ┣ 📜FoodNutritionResponse.swift
 ┃ ┃ ┃ ┃ ┗ 📜FoodSafetyRequest.swift
 ┃ ┃ ┃ ┗ 📂Judgement
 ┃ ┃ ┃ ┃ ┗ 📜Judgement.swift
 ┃ ┃ ┣ 📂Auth
 ┃ ┃ ┃ ┣ 📜AppleAuthCredentialParameter.swift
 ┃ ┃ ┃ ┣ 📜AuthParameter.swift
 ┃ ┃ ┃ ┗ 📜LoginProvider.swift
 ┃ ┃ ┣ 📂File
 ┃ ┃ ┃ ┗ 📜FileUploadResponse.swift
 ┃ ┃ ┣ 📂Health
 ┃ ┃ ┃ ┗ 📜HealthInfo.swift
 ┃ ┃ ┣ 📂Message
 ┃ ┃ ┃ ┣ 📜CreateMessageResponse.swift
 ┃ ┃ ┃ ┣ 📜Message.swift
 ┃ ┃ ┃ ┣ 📜MessageBody.swift
 ┃ ┃ ┃ ┗ 📜RetrieveMessageResponse.swift
 ┃ ┃ ┣ 📂Run
 ┃ ┃ ┃ ┣ 📜RunRequest.swift
 ┃ ┃ ┃ ┗ 📜RunResponse.swift
 ┃ ┃ ┣ 📂RunStep
 ┃ ┃ ┃ ┗ 📜RunStepResponse.swift
 ┃ ┃ ┣ 📂Thread
 ┃ ┃ ┃ ┗ 📜ThreadResponse.swift
 ┃ ┃ ┣ 📂ThreadAndRun
 ┃ ┃ ┃ ┣ 📜ThreadAndRunBody.swift
 ┃ ┃ ┃ ┗ 📜ThreadAndRunResponse.swift
 ┃ ┃ ┣ 📂UserInfo
 ┃ ┃ ┃ ┗ 📜UserInfo.swift
 ┃ ┃ ┗ 📜.DS_Store
 ┃ ┣ 📂Errors
 ┃ ┃ ┗ 📜StoreError.swift
 ┃ ┣ 📂Events
 ┃ ┃ ┗ 📜ToastEvent.swift
 ┃ ┣ 📂Interfaces
 ┃ ┃ ┣ 📂Facades
 ┃ ┃ ┃ ┗ 📜AssistantInteractionFacade.swift
 ┃ ┃ ┣ 📂Repositories
 ┃ ┃ ┃ ┣ 📜AuthRepository.swift
 ┃ ┃ ┃ ┣ 📜ChatRepository.swift
 ┃ ┃ ┃ ┣ 📜CreateThreadAndRunRepository.swift
 ┃ ┃ ┃ ┣ 📜ImageRepository.swift
 ┃ ┃ ┃ ┣ 📜MessageRepository.swift
 ┃ ┃ ┃ ┣ 📜OCRRepository.swift
 ┃ ┃ ┃ ┣ 📜RunRepository.swift
 ┃ ┃ ┃ ┣ 📜RunStepRepository.swift
 ┃ ┃ ┃ ┣ 📜TextPredictionRepository.swift
 ┃ ┃ ┃ ┗ 📜ThreadRepository.swift
 ┃ ┃ ┗ 📜Convertible.swift
 ┃ ┣ 📂UseCases
 ┃ ┃ ┣ 📂Assistant
 ┃ ┃ ┃ ┣ 📜CreateMessageUseCase.swift
 ┃ ┃ ┃ ┣ 📜CreateRunUseCase.swift
 ┃ ┃ ┃ ┣ 📜CreateThreadAndRunUseCase.swift
 ┃ ┃ ┃ ┣ 📜CreateThreadUseCase.swift
 ┃ ┃ ┃ ┣ 📜ImageClassifierUseCase.swift
 ┃ ┃ ┃ ┣ 📜ListRunStepUseCase.swift
 ┃ ┃ ┃ ┣ 📜PerformOCRUseCase.swift
 ┃ ┃ ┃ ┣ 📜PerplexityChatUseCase.swift
 ┃ ┃ ┃ ┣ 📜PredictFoodTextUseCase.swift
 ┃ ┃ ┃ ┣ 📜RetrieveMessageUseCase.swift
 ┃ ┃ ┃ ┗ 📜UploadImageUseCase.swift
 ┃ ┃ ┣ 📂Auth
 ┃ ┃ ┃ ┣ 📜DeleteAccountUseCase.swift
 ┃ ┃ ┃ ┣ 📜LoginUseCase.swift
 ┃ ┃ ┃ ┣ 📜LogoutUseCase.swift
 ┃ ┃ ┃ ┣ 📜ObserveAuthStateUseCase.swift
 ┃ ┃ ┃ ┗ 📜ReauthenticateUseCase.swift
 ┃ ┃ ┣ 📂User
 ┃ ┃ ┗ 📜.DS_Store
 ┃ ┗ 📜.DS_Store
 ┣ 📂Infrastructure
 ┃ ┣ 📜.DS_Store
 ┃ ┣ 📜AlertManager.swift
 ┃ ┣ 📜AnalyticsManager.swift
 ┃ ┣ 📜AppleAuthHelper.swift
 ┃ ┣ 📜CryptoUtils.swift
 ┃ ┣ 📜DIContainer.swift
 ┃ ┣ 📜ErrorMapper.swift
 ┃ ┣ 📜EventBus.swift
 ┃ ┣ 📜KeyboardObserver.swift
 ┃ ┣ 📜NavigationManager.swift
 ┃ ┣ 📜NetworkMonitor.swift
 ┃ ┗ 📜PromptGenerator.swift
 ┣ 📂Presentation
 ┃ ┣ 📂Extensions
 ┃ ┃ ┣ 📜Font+.swift
 ┃ ┃ ┣ 📜UIApplication+.swift
 ┃ ┃ ┗ 📜UIImage+.swift
 ┃ ┣ 📂Pages
 ┃ ┃ ┗ 📜HealthInfoSetUpPage.swift
 ┃ ┣ 📂Sessions
 ┃ ┃ ┗ 📜UserSession.swift
 ┃ ┣ 📂ViewModels
 ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┣ 📜MainViewModel.swift
 ┃ ┃ ┣ 📜OnboardingViewModel.swift
 ┃ ┃ ┗ 📜ResultViewModel.swift
 ┃ ┣ 📂Views
 ┃ ┃ ┣ 📂Account
 ┃ ┃ ┃ ┗ 📜AccountView.swift
 ┃ ┃ ┣ 📂Account 2
 ┃ ┃ ┣ 📂HealthInfoSetUp
 ┃ ┃ ┃ ┣ 📜AllergiesInfoSetUpView.swift
 ┃ ┃ ┃ ┣ 📜BasicInfoSetUpView.swift
 ┃ ┃ ┃ ┣ 📜DisclaimerView.swift
 ┃ ┃ ┃ ┣ 📜FlowLayout.swift
 ┃ ┃ ┃ ┣ 📜HealthInfoConfirmView.swift
 ┃ ┃ ┃ ┣ 📜HealthInfoEditView.swift
 ┃ ┃ ┃ ┣ 📜HealthInfoItemEditSheet.swift
 ┃ ┃ ┃ ┣ 📜HealthInfoListView.swift
 ┃ ┃ ┃ ┣ 📜InfoSetUpStartView.swift
 ┃ ┃ ┃ ┗ 📜MedicalInfoSetUpView.swift
 ┃ ┃ ┣ 📂Main
 ┃ ┃ ┃ ┣ 📜ImagePicker.swift
 ┃ ┃ ┃ ┣ 📜MainView.swift
 ┃ ┃ ┃ ┗ 📜SeedlowSheet.swift
 ┃ ┃ ┣ 📂Main 2
 ┃ ┃ ┣ 📂Onboarding
 ┃ ┃ ┃ ┣ 📜OnboardingPage.swift
 ┃ ┃ ┃ ┣ 📜OnboardingTabContent.swift
 ┃ ┃ ┃ ┣ 📜SplashView.swift
 ┃ ┃ ┃ ┗ 📜WelcomeView.swift
 ┃ ┃ ┣ 📂Onboarding 2
 ┃ ┃ ┣ 📂Purchase
 ┃ ┃ ┃ ┗ 📜PurchaseView.swift
 ┃ ┃ ┣ 📂Purchase 2
 ┃ ┃ ┣ 📂Result
 ┃ ┃ ┃ ┣ 📜LoadingView.swift
 ┃ ┃ ┃ ┗ 📜ResultView.swift
 ┃ ┃ ┣ 📂Result 2
 ┃ ┃ ┣ 📂Setting
 ┃ ┃ ┃ ┗ 📜SettingView.swift
 ┃ ┃ ┣ 📂Setting 2
 ┃ ┃ ┣ 📜ContentView.swift
 ┃ ┃ ┗ 📜CustomAlertView.swift
 ┃ ┗ 📜.DS_Store
 ┣ 📂Preview Content
 ┃ ┗ 📂Preview Assets.xcassets
 ┃ ┃ ┗ 📜Contents.json
 ┣ 📂Resources
 ┃ ┣ 📂Assets.xcassets
 ┃ ┃ ┣ 📂AccentColor.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂AppIcon.appiconset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜100.png
 ┃ ┃ ┃ ┣ 📜102.png
 ┃ ┃ ┃ ┣ 📜1024.png
 ┃ ┃ ┃ ┣ 📜108.png
 ┃ ┃ ┃ ┣ 📜114.png
 ┃ ┃ ┃ ┣ 📜120.png
 ┃ ┃ ┃ ┣ 📜128.png
 ┃ ┃ ┃ ┣ 📜144.png
 ┃ ┃ ┃ ┣ 📜152.png
 ┃ ┃ ┃ ┣ 📜16.png
 ┃ ┃ ┃ ┣ 📜167.png
 ┃ ┃ ┃ ┣ 📜172.png
 ┃ ┃ ┃ ┣ 📜180.png
 ┃ ┃ ┃ ┣ 📜196.png
 ┃ ┃ ┃ ┣ 📜20.png
 ┃ ┃ ┃ ┣ 📜216.png
 ┃ ┃ ┃ ┣ 📜234.png
 ┃ ┃ ┃ ┣ 📜256.png
 ┃ ┃ ┃ ┣ 📜258.png
 ┃ ┃ ┃ ┣ 📜29.png
 ┃ ┃ ┃ ┣ 📜32.png
 ┃ ┃ ┃ ┣ 📜40.png
 ┃ ┃ ┃ ┣ 📜48.png
 ┃ ┃ ┃ ┣ 📜50.png
 ┃ ┃ ┃ ┣ 📜512.png
 ┃ ┃ ┃ ┣ 📜55.png
 ┃ ┃ ┃ ┣ 📜57.png
 ┃ ┃ ┃ ┣ 📜58.png
 ┃ ┃ ┃ ┣ 📜60.png
 ┃ ┃ ┃ ┣ 📜64.png
 ┃ ┃ ┃ ┣ 📜66.png
 ┃ ┃ ┃ ┣ 📜72.png
 ┃ ┃ ┃ ┣ 📜76.png
 ┃ ┃ ┃ ┣ 📜80.png
 ┃ ┃ ┃ ┣ 📜87.png
 ┃ ┃ ┃ ┣ 📜88.png
 ┃ ┃ ┃ ┣ 📜92.png
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂Dish.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜dish 1.png
 ┃ ┃ ┃ ┣ 📜dish 2.png
 ┃ ┃ ┃ ┗ 📜dish 3.png
 ┃ ┃ ┣ 📂Logo.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜logo 1.png
 ┃ ┃ ┃ ┣ 📜logo 2.png
 ┃ ┃ ┃ ┗ 📜logo 3.png
 ┃ ┃ ┣ 📂Page1.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Page 1.png
 ┃ ┃ ┃ ┣ 📜Page 2.png
 ┃ ┃ ┃ ┗ 📜Page 3.png
 ┃ ┃ ┣ 📂Page2.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Page 2.png
 ┃ ┃ ┃ ┣ 📜Page 3.png
 ┃ ┃ ┃ ┗ 📜Page 4.png
 ┃ ┃ ┣ 📂Page3.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Page 3.png
 ┃ ┃ ┃ ┣ 📜Page 4.png
 ┃ ┃ ┃ ┗ 📜Page 5.png
 ┃ ┃ ┣ 📂Setting.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┗ 📜Setting.png
 ┃ ┃ ┣ 📂attention.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜attention 1.png
 ┃ ┃ ┃ ┣ 📜attention 2.png
 ┃ ┃ ┃ ┗ 📜attention.png
 ┃ ┃ ┣ 📂back.imageset
 ┃ ┃ ┃ ┣ 📜Back 1.png
 ┃ ┃ ┃ ┣ 📜Back 2.png
 ┃ ┃ ┃ ┣ 📜Back 3.png
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂capture.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜capture 1.png
 ┃ ┃ ┃ ┣ 📜capture 2.png
 ┃ ┃ ┃ ┗ 📜capture.png
 ┃ ┃ ┣ 📂cautionTriangle.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Yellow Triangle Illust 1.png
 ┃ ┃ ┃ ┣ 📜Yellow Triangle Illust 2.png
 ┃ ┃ ┃ ┗ 📜Yellow Triangle Illust.png
 ┃ ┃ ┣ 📂check.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜check 1.png
 ┃ ┃ ┃ ┣ 📜check 2.png
 ┃ ┃ ┃ ┗ 📜check.png
 ┃ ┃ ┣ 📂checkSmall.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┗ 📜checkSmall.png
 ┃ ┃ ┣ 📂chevronRight.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜chevron 1.png
 ┃ ┃ ┃ ┣ 📜chevron 2.png
 ┃ ┃ ┃ ┗ 📜chevron.png
 ┃ ┃ ┣ 📂clipboardIllust.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Clipboard Illust 1.png
 ┃ ┃ ┃ ┣ 📜Clipboard Illust 2.png
 ┃ ┃ ┃ ┣ 📜Clipboard Illust.png
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂close.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Close 1.png
 ┃ ┃ ┃ ┣ 📜Close 2.png
 ┃ ┃ ┃ ┣ 📜Close 3.png
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂closeSmall.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜closeSmall 1.png
 ┃ ┃ ┃ ┣ 📜closeSmall 2.png
 ┃ ┃ ┃ ┗ 📜closeSmall.png
 ┃ ┃ ┣ 📂errorLight.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Error Light 1.png
 ┃ ┃ ┃ ┣ 📜Error Light 2.png
 ┃ ┃ ┃ ┗ 📜Error Light.png
 ┃ ┃ ┣ 📂hill.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Hill Illust 1.png
 ┃ ┃ ┃ ┣ 📜Hill Illust 2.png
 ┃ ┃ ┃ ┗ 📜Hill Illust.png
 ┃ ┃ ┣ 📂negative.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂negativeX.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Red X Illust 1.png
 ┃ ┃ ┃ ┣ 📜Red X Illust 2.png
 ┃ ┃ ┃ ┗ 📜Red X Illust.png
 ┃ ┃ ┣ 📂neutral0.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral100.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral200.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral300.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral400.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral50.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral500.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral600.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral700.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral800.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂neutral900.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂offblack.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂offwhite.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂onboarding1.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Onboarding 1 Illust 1.png
 ┃ ┃ ┃ ┣ 📜Onboarding 1 Illust 2.png
 ┃ ┃ ┃ ┗ 📜Onboarding 1 Illust.png
 ┃ ┃ ┣ 📂onboarding2.imageset
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Onboarding 2 Illust 1.png
 ┃ ┃ ┃ ┣ 📜Onboarding 2 Illust 2.png
 ┃ ┃ ┃ ┗ 📜Onboarding 2 Illust.png
 ┃ ┃ ┣ 📂positive.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂positiveCircle.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜_Green Circle Illust 1.png
 ┃ ┃ ┃ ┣ 📜_Green Circle Illust 2.png
 ┃ ┃ ┃ ┗ 📜_Green Circle Illust.png
 ┃ ┃ ┣ 📂redo.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Redo 3.png
 ┃ ┃ ┃ ┣ 📜Redo 4.png
 ┃ ┃ ┃ ┗ 📜Redo.png
 ┃ ┃ ┣ 📂seedlow.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Seed Low Illust 1.png
 ┃ ┃ ┃ ┣ 📜Seed Low Illust 2.png
 ┃ ┃ ┃ ┗ 📜Seed Low Illust.png
 ┃ ┃ ┣ 📂warning.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂welcomeGift.imageset
 ┃ ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┣ 📜Gift Illust 1.png
 ┃ ┃ ┃ ┣ 📜Gift Illust 2.png
 ┃ ┃ ┃ ┗ 📜Gift Illust.png
 ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┗ 📜Contents.json
 ┃ ┣ 📂EmbeddingValue
 ┃ ┃ ┗ 📜text_embeddings.json
 ┃ ┣ 📂FoodDetectionModel
 ┃ ┃ ┣ 📂MobileCLIPImageEncoder.mlpackage
 ┃ ┃ ┃ ┣ 📂Data
 ┃ ┃ ┃ ┃ ┗ 📂com.apple.CoreML
 ┃ ┃ ┃ ┃ ┃ ┣ 📂weights
 ┃ ┃ ┃ ┃ ┃ ┃ ┗ 📜weight.bin
 ┃ ┃ ┃ ┃ ┃ ┗ 📜model.mlmodel
 ┃ ┃ ┃ ┗ 📜Manifest.json
 ┃ ┃ ┣ 📜.DS_Store
 ┃ ┃ ┗ 📜FoodTextDetection.mlmodel
 ┃ ┣ 📜.DS_Store
 ┃ ┣ 📜GoogleService-Info.plist
 ┃ ┣ 📜Info.plist
 ┃ ┣ 📜Prelude.storekit
 ┃ ┣ 📜Secrets.xcconfig
 ┃ ┣ 📜loadingBloomPot.json
 ┃ ┗ 📜splashTangtang.json
 ┣ 📂Shared
 ┃ ┣ 📜Localization.swift
 ┃ ┗ 📜Store.swift
 ┣ 📜.DS_Store
 ┣ 📜Prelude.entitlements
 ┣ 📜PreludeApp.swift
 ┗ 📜Products.plist
```



### 📌 Git Convention & Strategy
**Git Strategy**

![스크린샷 2024-07-11 오후 9 53 16](https://github.com/Hamstar-SeSACTHON/iOS-Temp/assets/114010099/6cc2d8eb-fe5a-43a0-9c2b-8b32ab742c9d)


`main` : 개발이 완료된 산출물이 저장될 공간

`develop` : feature 브랜치에서 구현된 기능들이 merge될 브랜치

`feature` : 기능을 개발하는 브랜치, 이슈별/작업별로 브랜치를 생성하여 기능을 개발한다

`release` : 릴리즈를 준비하는 브랜치, 릴리즈 직전 QA 기간에 사용한다

`hotfix` : 버그를 수정하는 브랜치

<br />

**Git Convention**

* **이슈**
  1. 이슈를 등록할 때 맨 앞에 이슈 종류 쓰기 (예: feat: 홈 UI 구현)
  2. 템플릿 사용
  3. 이슈에 맞는 label 달기

  ex) 이슈 템플릿
```## Description
설명을 작성하세요.

## To-do
- [ ] todo
- [ ] todo
```

<br />

* **브랜치**
  
브랜치명 = #이슈 번호/작업할 내용

ex) `#3/HomeViewUI`

<br />

* **커밋**
  
커밋 메시지 앞에 이슈: 넣기

ex) `feat: 홈 UI 구현`

<br />

* **태그**
  
`[HOTFIX]` : issue나, QA에서 급한 버그 수정에 사용

`[Fix]` : 버그, 오류 해결

`[Style]` : 코드 포맷팅, 코드 변경이 없는 경우

`[Feat]` : 새로운 기능 구현

`[Delete]` : 쓸모없는 코드 삭제

`[Docs]` : README나 WIKI 등의 문서 개정

`[Chores]` : 코드 수정, 내부 파일 수정, 빌드 업무 수정, 패키지 매니저 수정

`[Refactor]` : 전면 수정이 있을 때 사용합니다
