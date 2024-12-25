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
struct JunctionApp: App {
    @StateObject private var diContainer = DIContainer.shared
    @StateObject private var alertManager = AlertManager.shared
    @StateObject private var store = Store()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var userSession = UserSession(userRepository: DIContainer.shared.resolve(UserRepository.self)!,
                                                       loginUseCase: DIContainer.shared.resolve(LoginUseCase.self)!,
                                                       logOutUseCase: DIContainer.shared.resolve(LogOutUseCase.self)!,
                                                       deleteAccountUseCase: DIContainer.shared.resolve(DeleteAccountUseCase.self)!,
                                                       observeAuthStateUseCase: DIContainer.shared.resolve(ObserveAuthStateUseCase.self)!)
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(SwiftDataSource.shared.container)
                .environmentObject(alertManager)
                .environmentObject(diContainer)
                .environmentObject(navigationManager)
                .environmentObject(store)
                .environmentObject(userSession)
                
                
        }
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    
