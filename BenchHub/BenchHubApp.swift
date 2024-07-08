//
//  BenchHubApp.swift
//  BenchHub
//
//  Created by Shun Sato on 2023/12/29.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import FirebaseMessaging
import UserNotifications
import FirebaseFirestore

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let providerFactory = MyAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().token { token, error in
            if let error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token {
                print("FCM registration token: \(token)")
            }
        }
        
        return true
    }
    
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }
    
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken = ""
        for index in 0 ..< deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
        }
        print("Received an APNs device token: \(readableToken)")
    }
    
    // FCMトークンをFirestoreに保存するメソッド
     private func saveFCMTokenToFirestore(token: String) {
         let db = Firestore.firestore()
         db.collection("fcmTokens").document(token).setData([:]) { error in
             if let error = error {
                 print("Error saving FCM token: \(error)")
             } else {
                 print("FCM token saved successfully")
             }
         }
     }

}

    extension AppDelegate: MessagingDelegate {
        @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("Firebase token: \(String(describing: fcmToken))")
            if let token = fcmToken {
                saveFCMTokenToFirestore(token: token) // FCMトークンを保存
            }
        }
    }

    extension AppDelegate: UNUserNotificationCenterDelegate {
        func userNotificationCenter(
            _: UNUserNotificationCenter,
            willPresent _: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            completionHandler([[.banner, .list, .sound]])
        }
        
        func userNotificationCenter(
            _: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            let userInfo = response.notification.request.content.userInfo
            NotificationCenter.default.post(
                name: Notification.Name("didReceiveRemoteNotification"),
                object: nil,
                userInfo: userInfo
            )
            completionHandler()
        }
}

@main
struct YourApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(isShowReviewSheet: false, isPost: false)
                //TestView()
            }
        }
    }
}
