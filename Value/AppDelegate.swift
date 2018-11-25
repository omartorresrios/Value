//
//  AppDelegate.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import Locksmith

let reachability = Reachability()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        
    }
    
    var window: UIWindow?
    var reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        print("Firebase registration token: ", FIRInstanceID.instanceID().token()!)
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        
        attemtRegisterForNotifications(application: application)
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let myProfileController = MyProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let userInfo = response.notification.request.content.userInfo
        
        let review_id = userInfo["review_id"] as? String ?? ""
        let sender_fullname = userInfo["sender_fullname"] as? String ?? ""
        
        myProfileController.notificationReviewId = Int(review_id)
        myProfileController.senderFullname = sender_fullname
        myProfileController.isComingFromNotification = true
        
        if let mainTabBarController = self.window?.rootViewController as? MainTabBarController {
            
            mainTabBarController.selectedIndex = 2
            
            mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
            
            if let homeNavController = mainTabBarController.viewControllers?.last as? UINavigationController {
                homeNavController.pushViewController(myProfileController, animated: true)
            }
        }
        
    }
    
    //listen for user notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    private func attemtRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS")
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        // User notification auth
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print("Failed to request auth: ", error)
                return
            }
            
            if granted {
                print("Auth granted")
            } else {
                print("Auth denied")
            }
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications: ", deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

