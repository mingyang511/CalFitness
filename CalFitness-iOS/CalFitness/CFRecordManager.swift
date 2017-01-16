//
//  Record.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFRecordManager
{
    
    // Method to create new record and save to server
    class func saveNewRecord(step:NSNumber, date:NSDate, completion:(success:Bool, goal:Float, date:NSDate) -> Void)
    {
        // Create new record
        let record = createNewRecord(step, date:date)
        
        // Save record in background and retrieve goal
        record.saveInBackgroundWithBlock
        {
            (success:Bool, error:NSError?) in
            
            let goal = record["goal"] as? Float
            CFRecordManager.setGoal(goal!, forDate: date)
            completion(success:success, goal:goal!, date:date);
        }
    }
    
    // Method to create new record
    class func createNewRecord(step:NSNumber, date:NSDate) -> CFRecord
    {
        let record = CFRecord()
        record.step = step;
        record.date = CFDateHelper.getDateString(date);
        record.user = PFUser.currentUser();
        return record;
    }
    
    // Method to fetch records from server
    class func fetchRecordsFromServer()
    {
        fetchRecordsFromServerInBackground
        {
            (success, objects) in
        }
    }

    // Method to fectch records from server in background
    class func fetchRecordsFromServerInBackground(completion:(success:Bool, objects:[CFRecord]?) -> Void)
    {
        if (PFUser.currentUser() == nil)
        {
            completion(success: false, objects: [CFRecord]());
            return
        }
        
        let query = PFQuery(className:"Record")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.orderByDescending("date")
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) in
            
            var uniqueObjects = [CFRecord]()
            var dates = [String]()
            if !(objects == nil)
            {
                if objects?.count > 0 {
                    for i in 0 ... objects!.count-1
                    {
                        let object = objects![i] as! CFRecord
                        if dates.contains(object["date"] as! String) == false
                        {
                            dates.append(object["date"] as! String)
                            uniqueObjects.append(object)
                        }
                    }
                }
                
                CFRecord.unpinAllObjectsInBackgroundWithBlock(
                {
                    (success:Bool, error:NSError?) in
                    CFRecord.pinAllInBackground(uniqueObjects, block:
                    {
                        (success:Bool, error:NSError?) in
                        completion(success: true, objects: uniqueObjects);
                    });
                })
            }
            else
            {
                completion(success: false, objects: uniqueObjects);
            }
        }
    }
    
    // Method
    class func getRecordsForLastWeek(completion:(success:Bool, objects:[CFRecord]?) -> Void)
    {
        if (PFUser.currentUser() == nil)
        {
            completion(success: false, objects: [CFRecord]());
            return
        }
        
        let query = PFQuery(className:"Record")
        let firstDay = CFDateHelper.beginningOfDate(NSDate().dateByAddingTimeInterval(-3600*24*6))
        let today = NSDate()

        query.fromLocalDatastore()
        
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("date", greaterThanOrEqualTo: CFDateHelper.getDateString(firstDay))
        query.whereKey("date", lessThanOrEqualTo: CFDateHelper.getDateString(today))
        query.orderByAscending("date")
        
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) in
            
            completion(success: true, objects: objects as! [CFRecord]);
        }
    }

    // Method to retrieve the goal for today
    class func getGoalForToday() -> Float
    {
        let goal = NSUserDefaults.standardUserDefaults().floatForKey(CFDateHelper.getDateString(NSDate()) as String)
        return goal;
    }
    
    // Method to store goal
    class func setGoal(goal:NSNumber, forDate date:NSDate)
    {
        NSUserDefaults.standardUserDefaults().setFloat(goal.floatValue, forKey: CFDateHelper.getDateString(date) as String)
    }
}
