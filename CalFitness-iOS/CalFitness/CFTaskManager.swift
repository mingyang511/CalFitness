//
//  CFNotification.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFTaskManager
{
    class func collectNewRecord(background:Bool, completion:(success:Bool) -> Void)
    {
        CFHealthController.sharedInstance.fetchRecordOfToday(background)
        {
            (success) in
            completion(success:success)
        }
    }
}
