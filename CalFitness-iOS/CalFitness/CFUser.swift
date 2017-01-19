//
//  CFUser.swift
//  CalFitnesss
//
//  Created by Lee on 1/16/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

enum CFUserGroup: NSInteger
{
    case SteadyGoalWithNoNotification = 1 // Steady goal at 10,000 steps and no push notification.
    case SimpleGoalWithRandomNotification = 2 // Simple goal step setting and random push notification
    case CustomizedGoalWithCustomizedNotification = 3 // Goal algorithm and customized push notification
    case Unknown
}

class CFUser : PFUser
{
    @NSManaged var group: NSNumber
    
    func currentUser() -> CFUser?
    {
        return CFUser.currentUser() 
    }
    
    // Method to cehck user's group
    func userGroup() -> CFUserGroup
    {
        if let user = PFUser.currentUser()
        {
            let group = user["group"] as! CFUserGroup
            return group
        }
        
        return CFUserGroup.Unknown
    }
}
