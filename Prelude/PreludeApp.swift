//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import CloudKit
import FirebaseCore
import SwiftUI
import SwiftData

@main
struct PreludeApp: App {
    @StateObject private var diContainer = DIContainer.shared
    @StateObject private var alertManager = AlertManager.shared
    @StateObject private var store = Store()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var userSession = UserSession(userRepository: DIContainer.shared.resolve(UserRepository.self)!,
                                                       loginUseCase: DIContainer.shared.resolve(LoginUseCase.self)!,
                                                       logOutUseCase: DIContainer.shared.resolve(LogOutUseCase.self)!,
                                                       reauthenticateUseCase: DIContainer.shared.resolve(ReauthenticateUseCase.self)!,
                                                       deleteAccountUseCase: DIContainer.shared.resolve(DeleteAccountUseCase.self)!,
                                                       observeAuthStateUseCase: DIContainer.shared.resolve(ObserveAuthStateUseCase.self)!)
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(SwiftDataSource.shared.container!)
                .environmentObject(alertManager)
                .environmentObject(keyboardObserver)
                .environmentObject(diContainer)
                .environmentObject(navigationManager)
                .environmentObject(store)
                .environmentObject(userSession)
                .environment(\.plTypographySet, currentLocalizationTypographySet())
        }
        
    }
    
    func currentLocalizationTypographySet() -> PLTypographySet {
        let identifier = Locale.current.identifier
        guard let languageCode = Locale.current.language.languageCode else { return PLTypographySetKey.defaultValue }
        switch languageCode {
            case "ko":
                return PLTypographySet(display: KoreanTypographySet.display,
                                       heading1: KoreanTypographySet.heading1,
                                       heading2: KoreanTypographySet.heading2,
                                       title1: KoreanTypographySet.title1,
                                       title2: KoreanTypographySet.title2,
                                       label: KoreanTypographySet.label,
                                       paragraph1: KoreanTypographySet.paragraph1,
                                       paragraph2: KoreanTypographySet.paragraph2,
                                       caption: KoreanTypographySet.caption)
                
            default:
                return PLTypographySetKey.defaultValue
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)

        if notification?.subscriptionID == "UserInfoSubscriptionID" {
            ICloudDataSource.shared.processNotification(userInfo: userInfo)
        }
        completionHandler(.newData)
    }

}
    
