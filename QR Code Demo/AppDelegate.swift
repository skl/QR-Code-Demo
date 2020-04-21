//
//  AppDelegate.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var appState: AppState?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("requestAuthorization error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        let approveAction = UNNotificationAction(identifier: "APPROVE_SIGN_IN_ACTION", title: "Approve", options: UNNotificationActionOptions(rawValue: 0))
        let denyAction = UNNotificationAction(identifier: "DENY_SIGN_IN_ACTION", title: "Deny", options: UNNotificationActionOptions(rawValue: 0))
        let signInRequestCategory = UNNotificationCategory(identifier: "SIGN_IN_REQUEST", actions: [approveAction, denyAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([signInRequestCategory])
        
        notificationCenter.delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            completionHandler()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let userInfo = response.notification.request.content.userInfo
        let signInAccount = userInfo["SIGN_IN_ACCOUNT"] as! String
        let signInIssuer = userInfo["SIGN_IN_ISSUER"] as! String
        appState?.lastSignInRequest.account = signInAccount
        appState?.lastSignInRequest.issuer = signInIssuer
        
        switch response.actionIdentifier {
        case "APPROVE_SIGN_IN_ACTION":
            ApiStub.approved(request: appState!.lastSignInRequest)
            break
            
        case "DENY_SIGN_IN_ACTION":
            ApiStub.denied(request: appState!.lastSignInRequest)
            break
            
        default:
            appState?.showAlert = true
            break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

