//
//  JunctionApp.swift
//  Junction
//
//  Created by 송지혁 on 8/10/24.
//

import CloudKit
import ComposableArchitecture
import FirebaseCore
import SwiftUI
import SwiftData

@main
struct PreludeApp: App {
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let appFeature = Store(initialState: AppFeature.State()) { AppFeature() }
    
    var body: some Scene {
        WindowGroup {
            SplashView(store: appFeature)
                .modelContainer(SwiftDataSource.shared.container!)
                .environmentObject(keyboardObserver)
                .environment(\.plTypographySet, currentLocalizationTypographySet())
                .dynamicTypeSize(.medium)
        }
        
    }
    
    func currentLocalizationTypographySet() -> PLTypographySet {
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
    
