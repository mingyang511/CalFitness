//
//  CFAuthHelper.swift
//  CalFitnesss
//
//  Created by Lee on 1/15/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFAuthHelper
{
    class func login(application: UIApplication, completion:(success:Bool) -> Void)
    {
        PFAnonymousUtils.logInWithBlock(
        {
            (user:PFUser?, error:NSError?) in
            
            if (error == nil)
            {
                CFHealthKitHelper.sharedInstance.fetchRecordsOfPastWeek(
                {
                    (success) in
                    completion(success: true)
                })
            }
            else
            {
                CFTaskManager.collectNewRecord(false)
                {
                    (success) in
                    completion(success: false)
                }
            }
        })
    }
}
