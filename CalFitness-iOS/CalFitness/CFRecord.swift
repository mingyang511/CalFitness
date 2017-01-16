//
//  CFRecord.swift
//  CalFitnesss
//
//  Created by Lee on 1/15/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFRecord : PFObject, PFSubclassing
{
    @NSManaged var user: PFUser?
    @NSManaged var date: NSString
    @NSManaged var step: NSNumber
    @NSManaged var goal: NSNumber
    @NSManaged var notificationMessage: NSString
    @NSManaged var notificationCategory: NSNumber
    @NSManaged var notificationPushedAt: NSDate
   
    override class func initialize()
    {
        struct Static
        {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken)
        {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String
    {
        return "Record"
    }
    
}
