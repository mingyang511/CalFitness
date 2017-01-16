//
//  CFNotificationCenterHelper.swift
//  CalFitnesss
//
//  Created by Lee on 1/16/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

public class CFNotificationCenterHelper
{
    static var notificationCenter = NSNotificationCenter.defaultCenter()
    
    // ApplicationWillEnterForeground
    
    public class func addApplicationWillEnterForegroundObserver(observer: AnyObject, selector aSelector: Selector)
    {
        notificationCenter.addObserver(observer, selector: aSelector, name: "ApplicationWillEnterForeground", object: nil)
    }
    
    public class func postApplicationWillEnterForegroundNotification()
    {
        notificationCenter.postNotificationName("ApplicationWillEnterForeground", object: nil)
    }
    
    public class func removeApplicationWillEnterForegroundObserver(observer: AnyObject)
    {
        notificationCenter.removeObserver(observer)
    }
    
    // UserLogedIn
    
    public class func addUserLogedInObserver(observer: AnyObject, selector aSelector: Selector)
    {
        notificationCenter.addObserver(observer, selector: aSelector, name: "UserLogedIn", object: nil)
    }
    
    public class func postUserLogedInNotification()
    {
        notificationCenter.postNotificationName("UserLogedIn", object: nil)
    }
    
    public class func removeUserLogedInObserver(observer: AnyObject)
    {
        notificationCenter.removeObserver(observer, name: "UserLogedIn", object: nil)
    }
}
