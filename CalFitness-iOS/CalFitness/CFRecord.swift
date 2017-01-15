//
//  Record.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFRecord {
    class func saveNewRecord(steps:NSNumber,goal:NSNumber, date:NSDate, newGoal:Bool, completion:(success:Bool, goal:Float, date:NSDate) -> Void) {
        let record = newRecordObject(steps, goal:goal, date:date, newGoal:newGoal)
        record.saveInBackgroundWithBlock {(success:Bool, error:NSError?) in
            var goal = record["goal"] as? Float
            goal = (goal==nil || goal==0) ? CFStore.defaultGoal(): goal
            CFStore.setGoal(goal!, forDate: date)
            completion(success:success, goal: goal!, date:date);
        }
    }
    
    class func newRecordObject(steps:NSNumber, goal:NSNumber, date:NSDate, newGoal:Bool) -> PFObject {
        let record = PFObject(className: "Record")
        record["steps"] = steps;
        record["goal"] = goal;
        record["date"] = CFDate.getDateString(date);
        record["newGoal"] = newGoal;
        if ((PFUser.currentUser()) != nil) {
            record["user"] = PFUser.currentUser();
        }
        return record;
    }
}
