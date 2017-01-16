//
//  CFDate.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFDateHelper
{
    
    // Method to convert date to string
    class func getDateString(date:NSDate?) -> NSString
    {
        if let date = date
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(date)
        }
        return ""
    }
    
    // Method to convert string to date
    class func getDate(string:String?) -> NSDate
    {
        if let string = string
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.dateFromString(string)!
        }
        return NSDate()
    }
    
    // Method to get beginning of today
    class func beginningOfToday() -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
    
    // Method to get the beginning of date
    class func beginningOfDate(date:NSDate) -> NSDate
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate:date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
    
    // Method to compute the number of days since current user is created
    class func numberOfDays() -> Int
    {
        if let user = PFUser.currentUser()
        {
            let createdAt = user.createdAt
            let calendar: NSCalendar = NSCalendar.currentCalendar()
            let date1 = calendar.startOfDayForDate(createdAt!)
            let date2 = calendar.startOfDayForDate(NSDate())
            let flags = NSCalendarUnit.Day
            let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
            return components.day
        }
        return 0;
    }
}
