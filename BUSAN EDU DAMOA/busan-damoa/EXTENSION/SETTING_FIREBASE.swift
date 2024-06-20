//
//  SETTING_FIREBASE.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // 알림 받음.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let USERINFO = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        if let MSG_ID = USERINFO[GCM_MSG_ID_KEY] { print("알림 받음 MSG_ID: \(MSG_ID)") }
        
        print("알림 받음 userNotificationCenter", USERINFO)
        
//        UIApplication.shared.applicationIconBadgeNumber = 1
        
        // 푸시 배지
        VIEWCONTROLLER.PUSH_BADGE(BOARD_TYPE: USERINFO["board_type"] as? String ?? "", true)
        
        completionHandler([.alert, .sound, .badge])
    }
    
    // 알림 누름.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let USERINFO = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(USERINFO)
        
        if let MSG_ID = USERINFO[GCM_MSG_ID_KEY] { print("알림 누름 MSG_ID: \(MSG_ID)") }
        
        print("알림 누름 userNotificationCenter", USERINFO)
        
        // 푸시 배지
        VIEWCONTROLLER.PUSH_BADGE(BOARD_TYPE: USERINFO["board_type"] as? String ?? "", true)
        
        let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
        VC.modalTransitionStyle = .crossDissolve
        VC.PUSH_YN = true
        VC.BOARD_KEY = USERINFO["board_key"] as? String ?? ""
        VC.BOARD_TYPE = USERINFO["board_type"] as? String ?? ""
        WINDOW?.rootViewController = VC
        WINDOW?.makeKeyAndVisible()
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("FIREBASE TOKEN: \(fcmToken ?? "")")
        
        UserDefaults.standard.setValue("\(fcmToken ?? "")", forKey: "gcm_id")
        UserDefaults.standard.synchronize()
        
        let DATADICT: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: DATADICT)
    }
    
//    // 알림 받음.
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        if let MSG_ID = userInfo[GCM_MSG_ID_KEY] { print("알림 받음 Message ID: \(MSG_ID)") }
//
//        print("알림 받음 application", userInfo)
//
//        // 푸시 배지
//        VIEWCONTROLLER.PUSH_BADGE(BOARD_TYPE: userInfo["board_type"] as? String ?? "", true)
//    }
    
    // 알림 받음.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let MSG_ID = userInfo[GCM_MSG_ID_KEY] { print("알림 누름 MSG_ID: \(MSG_ID)") }
        
        // 전체 메시지를 인쇄하십시오.
        print("알림 받음 application", userInfo)
        
//        UIApplication.shared.applicationIconBadgeNumber += 1
        
        // 푸시 배지
        VIEWCONTROLLER.PUSH_BADGE(BOARD_TYPE: userInfo["board_type"] as? String ?? "", true)
        
        completionHandler(.newData)
    }
}
