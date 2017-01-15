//
//  CFDate.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation

class CFDate {
    class func getDateString(date:NSDate?) -> NSString {
        if let date = date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.stringFromDate(date)
        }
        return ""
    }
    
    class func getDate(string:String?) -> NSDate {
        if let string = string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.dateFromString(string)!
        }
        return NSDate()
    }
    
    class func beginningOfToday() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
    
    class func beginningOfDate(date:NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate:date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
}
