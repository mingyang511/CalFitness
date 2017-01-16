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
    
    // Method to register for remote notification
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation["user"] = PFUser.currentUser()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    // Method to receive remote notifications
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        let aps = userInfo["aps"] as! [String: AnyObject];
        let type = aps["type"] as! String;
 
        if type == "collect"
        {
            CFTaskManager.collectNewRecord (true)
            {
                (success) in
                completionHandler(.NewData);
            };
        }
        else
        {
            completionHandler(.NoData);
        }
    }
    
    // Method to perform background tasks
    func application(application: UIApplication, performFetchWithCompletionHandler
        completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        CFTaskManager.collectNewRecord(true)
        {
            (success) in
            completionHandler(.NewData);
        };
    }
    
    // Method to register remote notification
    func registerRemoteNotification(application:UIApplication)
    {
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
}
