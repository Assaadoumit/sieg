////
////  AppDelegate.swift
////  Siegma1
////
////  Created by MacBookPro on 2/7/19.
////  Copyright © 2019 MacBookPro. All rights reserved.
////
//////////////////////////           //My Try////          ////////////////////////////////////////////////////
import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseAnalytics
import UserNotifications
import SwiftyJSON


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, UIWebViewDelegate {
    var window: UIWindow?
    var myUrl: String = ""
    let  gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            
        }
        
        // Print full message.
        let Link = userInfo["Link"] as? String ?? ""
        print(Link)
        myUrl = Link
        
//        UIApplication.shared.applicationIconBadgeNumber = 0
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceivedPushNotification"), object: userInfo)
        
//        let vc = WebViewController()
//        vc.openWeb(wurl: Link)
//        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
//        func openNewLink(){
//            let delegate = UIApplication.shared.delegate as! WebViewController
//            let url = URL(string: "link")
//            let request = URLRequest(url: url!)
//            var urlRequest = URLRequest(url: url!)
//            urlRequest.cachePolicy = .returnCacheDataDontLoad
//            webView.loadRequest(request)
//
//        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func messaging(_ messaging: Messaging, didReceiveremoteMessage: MessagingRemoteMessage) {
        //         Convert to pretty-print JSON, just to show the message for testing
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        connectToFCM()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        connectToFCM()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    func tokenRefreshNorification(notification : NSNotification){
        let refreshedToken = InstanceID.instanceID().token()
        print("InstanceID Token: \(String(describing: refreshedToken))")
        FirebaseApp.configure()
        connectToFCM()
    }
    func connectToFCM(){
        Messaging.messaging().shouldEstablishDirectChannel = true

        Messaging.messaging().connect { (error) in
            if (error != nil){
                print("unable to connect to FCM \(error)")
            }else{
                print("Connected To FCM")
            }
        }
    }
 }

    @available(iOS 10, *)
    extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
    
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("user info is :" ,userInfo)
        
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound])
    }
    
    
 }
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message Data", remoteMessage.appData)
         Messaging.messaging().shouldEstablishDirectChannel = true
       
     }
    
  }


