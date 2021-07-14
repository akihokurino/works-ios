//
//  WorksApp.swift
//  Works
//
//  Created by akiho on 2021/07/14.
//

import Firebase
import FirebaseAuth
import SwiftUI

@main
struct WorksApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: RootCore.State(),
                    reducer: RootCore.reducer,
                    environment: RootCore.Environment(
                        mainQueue: .main,
                        backgroundQueue: .init(DispatchQueue.global(qos: .background))
                    )
                )
            )
            .onOpenURL { url in
                Auth.auth().canHandle(url)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}
