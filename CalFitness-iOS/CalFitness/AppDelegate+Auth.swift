
//
//  AppDelegate + Auth.swift
//  CalFitnesss
//
//  Created by Lee on 1/16/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

extension AppDelegate
{
    func performUserAuthVerification(application: UIApplication)
    {
        // Verify user session and ask to log in if necessary
        if((CFUser.currentUser()) == nil)
        {
            CFAuthHelper.performAuthVerification(application, completion:
                {
                    (success) in
                    
                    if (success)
                    {
                        self.registerRemoteNotification(application)
                    }
            })
        }
        else
        {
            self.registerRemoteNotification(application)
            CFNotificationCenterHelper.postApplicationWillEnterForegroundNotification()
        }
    }
    
    func performHealthKitAuthVerification(application: UIApplication)
    {
        // Authorize HealthKit
        if (!CFHealthKitHelper.sharedInstance.authorized)
        {
            CFHealthKitHelper.sharedInstance.authorizeHealthKit
            {
                (authorized,  error) -> Void in
                
                if authorized
                {
                    print("HealthKit authorization received.")
                }
                else
                {
                    print("HealthKit authorization denied!")
                    if error != nil
                    {
                        print("\(error)")
                    }
                }
            }
        }
    }
}
