//
//  CFStore.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse


class CFStore {
    
    class func getGoalForToday() -> Float {
        let goal = NSUserDefaults.standardUserDefaults().floatForKey(CFDate.getDateString(NSDate()) as String)
        return goal == 0 ? defaultGoal() : goal;
    }
    
    class func setGoal(goal:NSNumber, forDate date:NSDate) {
        NSUserDefaults.standardUserDefaults().setFloat(goal.floatValue, forKey: CFDate.getDateString(date) as String)
    }
    
    class func getRecordsForLastWeek (completion:(success:Bool, objects:[PFObject]?) -> Void) {
        if (PFUser.currentUser() == nil) {
            completion(success: false, objects: [PFObject]());
            return
        }
        
        let query = PFQuery(className:"Record")
        let firstDay = CFDate.beginningOfDate(NSDate().dateByAddingTimeInterval(-3600*24*6))
        let today = NSDate()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("date", greaterThanOrEqualTo: CFDate.getDateString(firstDay))
        query.whereKey("date", lessThanOrEqualTo: CFDate.getDateString(today))
        query.orderByAscending("date")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            completion(success: true, objects: objects);
        }
    }
    
    class func fetchRecordsFromServer () {
        fetchRecordsFromServerInBackground { (success, objects) in}
    }
    
    class func fetchConfigFromServer() {
        PFConfig.getConfigInBackgroundWithBlock {
            (config: PFConfig?, error: NSError?) -> Void in
        }
    }
    
    class func fetchUserFromServer() {
        PFUser.currentUser()?.fetchInBackground()
    }
    
    class func fetchRecordsFromServerInBackground (completion:(success:Bool, objects:[PFObject]?) -> Void) {
        if (PFUser.currentUser() == nil) {
            completion(success: false, objects: [PFObject]());
            return
        }
        
        let query = PFQuery(className:"Record")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.orderByDescending("date")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            var uniqueObjects = [PFObject]()
            var dates = [String]()
            if !(objects == nil) {
                if objects?.count > 0 {
                    for i in 0 ... objects!.count-1  {
                        let object = objects![i]
                        if dates.contains(object["date"] as! String) == false {
                            dates.append(object["date"] as! String)
                            uniqueObjects.append(object)
                        }
                    }
                }
                
                PFObject.unpinAllObjectsInBackgroundWithBlock({
                    (success:Bool, error:NSError?) in
                    PFObject.pinAllInBackground(uniqueObjects, block: {
                        (success:Bool, error:NSError?) in
                        completion(success: true, objects: uniqueObjects);
                    });
                })
            } else {
                completion(success: false, objects: uniqueObjects);
            }
        }
    }
    
    class func defaultGoal() -> Float {
        let config = PFConfig.currentConfig()
        var defaultGoal=config.objectForKey("defaultGoal") as? Float;
        defaultGoal = (defaultGoal==nil) ? 3 : defaultGoal;
        return defaultGoal!;
    }
    
    class func numberOfDays() -> Int {
        if let user = PFUser.currentUser() {
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
    
    class func isUserControled() -> Bool {
        if isControlOn() {
            if let user = PFUser.currentUser() {
                let isControl = user["isControl"]
                if !(isControl == nil) {
                    return isControl.boolValue
                }
            }
        }
        return false;
    }
    
    /*class func pinRecordsInBackground(records:[PFObject]) -> Void {
        var dates = [String]();
        for i in 0...records.count {
            let record = records[i];
            dates.append(record["date"] as! String)
        }
        
        let predicate = NSPredicate(format: "playerName = 'Dan Stemkosk'")
        var query = PFQuery(className: "GameScore", predicate: predicate)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            completion(success: true, objects: objects);
        }
    }*/
    
    private class func isControlOn() -> Bool {
        let config = PFConfig.currentConfig()
        let isControlOn=config.objectForKey("isControlOn")
        if !(isControlOn == nil) {
            return (isControlOn?.boolValue)!
        }
        return true;
    }
}
