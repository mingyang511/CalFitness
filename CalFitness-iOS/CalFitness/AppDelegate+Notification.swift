//
//  AppDelegate+Notification.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

extension AppDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation["user"] = PFUser.currentUser()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void){
        let aps = userInfo["aps"] as! [String: AnyObject];
        let type = aps["type"] as! String;
        
        if type == "create" {
            CFTask.createNewGoal {(success) in
                completionHandler(.NewData);
            };
        } else if type == "notify" {
            CFTask.notifyUser {(success) in
                completionHandler(.NewData);
            };
        } else if type == "collect" {
            CFTask.collectNewRecord (true) {(success) in
                completionHandler(.NewData);
            };
        } else {
            completionHandler(.NoData);
        }
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler
        completionHandler: (UIBackgroundFetchResult) -> Void) {
        CFTask.collectNewRecord(true)  { (success) in
            completionHandler(.NewData);
        };
    }
    
    func registerRemoteNotification(application:UIApplication) {
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
}
