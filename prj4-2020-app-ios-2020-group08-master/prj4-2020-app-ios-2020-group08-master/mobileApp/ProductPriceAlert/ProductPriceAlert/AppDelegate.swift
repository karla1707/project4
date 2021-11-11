//
//  AppDelegate.swift
//  ProductPriceAlert
//
//  Created by Daniyal on 31/03/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import UIKit
import SwiftUI
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var modalSheet = ModalSheet()
    var token : String = ""
    
    // If the app is NOT running and the user launches it by tapping the push notification, the push notification is passed to the app in this func:
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        registerForPushNotifications()

        if
            let notificationOption  = launchOptions?[.remoteNotification],
            let notification        = notificationOption as? NSDictionary,
            let alert              = notification["alert"] as? NSDictionary,
            let pId                = alert["productid"] as? Int
        {
            modalSheet.productId = "\(pId)"
            modalSheet.show = true
        }


        return true
    }
    
    // Show a notification alert when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
    }
    
    // react to the notification alert when the app is in the foreground and the user taps on it
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let content = response.notification.request.content.userInfo
        print(content)
        
        // use the payload to show the modal sheet for product
        if
            let alert   = content["alert"] as? NSDictionary,
            let pId     = alert["productid"] as? Int
        {
            modalSheet.productId = "\(pId)"
            modalSheet.show = true
        }
        completionHandler()
        
    }
    
    // If the app is running in the background or foreground it tells the app that a remote notification arrived that indicates there is data to be fetched.
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard
            let _ = userInfo["alert"] as? NSDictionary
            else
        {
            completionHandler(.failed)
            return
        }
    }

    // Here you register the device token in the backend
    // Note: device token changes each time you "Uninstall" the app and install it again.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // takes deviceToken and converting it to a string.
        //  In our app, we would send this token to our server, so that it could be saved and later used for sending notifications.
        let tokenParts = deviceToken.map { data in
            String(format: "%02.2hhx", data)
        }
        token = tokenParts.joined()
        print("Device Token: \(token)")
    }

    // if didRegisterForRemoteNotificationsWithDeviceToken is not successful, iOS calls this method:
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("!!!===> Failed to register: \(error)")
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
    
    
    // ensures the app will attempt to register for push notifications any time it’s launched.
    func registerForPushNotifications() {
        // This is the notification request popup when the app is installed for the first time on the device.
        // handles all notification-related activities in the app. request authorization to show notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in

            // The call to getNotificationSettings() is important as the user can, at any time, go into the Settings app and change their notification permissions.
            // The guard avoids making this call in cases where permission was not granted.
            guard granted else {
                print("Permission for notifications DID NOT granted.")
                return
            }
            
            print("Granted permission for notifications: \(granted)")
            self?.getNotificationSettings()
        }
    }
    
    // if the user declines the permissions in the notification alert "Don't allow" button.
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            print("Notification settings: \(settings)")
            
            // Verify that the user has granted notification permissions
            guard settings.authorizationStatus == .authorized else { return }
            
            // If so, you call UIApplication.shared.registerForRemoteNotifications() to kick off registration with the Apple Push Notification service.
            // We need to call it on the main thread, or we’ll receive a runtime warning.
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

