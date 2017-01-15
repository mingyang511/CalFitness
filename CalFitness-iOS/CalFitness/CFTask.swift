//
//  CFNotification.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFTask {
    class func createNewGoal(completion:(success:Bool) -> Void) {
        let date = NSDate().dateByAddingTimeInterval(3600*24)

        if (PFUser.currentUser() == nil) {
            completion(success: false);
            CFStore.setGoal(CFStore.defaultGoal(), forDate:date)
            return;
        }
        
        if let user = PFUser.currentUser() {
            let query = PFQuery(className:"Record")
            query.fromLocalDatastore()
            query.whereKey("user", equalTo:PFUser.currentUser()!)
            query.whereKey("date", lessThanOrEqualTo: CFDate.getDateString(NSDate()))
            query.whereKey("date", greaterThanOrEqualTo: CFDate.getDateString(user.createdAt))
            query.orderByAscending("date")
            query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) in
                if (objects?.count < 1) {
                    CFStore.setGoal(CFStore.defaultGoal(), forDate:date)
                    CFRecord.saveNewRecord(0,
                        goal:CFStore.defaultGoal(),
                        date:date,
                        newGoal: true,
                        completion:{(success) in
                            completion(success: true)
                    });
                } else {
                    let goals = NSMutableArray();
                    let steps = NSMutableArray();
                    for object in (objects)! {
                        goals.addObject(String(object["goal"]))
                        steps.addObject(String(object["steps"]))
                    }
                    
                    let goalString = (NSArray(array:goals) as? [String])!.joinWithSeparator(",");
                    let stepString = (NSArray(array:steps) as? [String])!.joinWithSeparator(",");
                    let isControl = (CFStore.isUserControled() == true) ? 1 : 0;
                    let url =  String(format: "%@/%@/%@/%d", "http://128.32.192.76/get_goal", stepString, goalString, isControl)
                    let request = NSURLRequest(URL: NSURL(string: url)!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{
                        (response: NSURLResponse?, data: NSData?, error: NSError?)-> Void in
                        if (error == nil) {
                            let goal = (NSString(data: data!, encoding: NSUTF8StringEncoding)?.floatValue)!
                            CFStore.setGoal(goal, forDate:date)
                            CFRecord.saveNewRecord(0,
                                goal:goal,
                                date:date,
                                newGoal: true,
                                completion:{(success) in
                                    completion(success: true)
                            });
                        } else {
                            CFStore.setGoal(CFStore.defaultGoal(), forDate:date)
                            CFRecord.saveNewRecord(0, goal:CFStore.defaultGoal(), date:date,
                                newGoal: true, completion:{
                                    (success) in
                                    completion(success: true)
                            });
                        }
                    });
                }
            }
        }
    }
    
    class func collectNewRecord(background:Bool, completion:(success:Bool) -> Void) {
        HealthController.sharedInstance.getRecordOfToday(background) { (success) in
            completion(success:success)
        }
    }
    
    class func notifyUser(completion:(success:Bool) -> Void) {
        if (PFUser.currentUser() == nil) {
            completion(success: false);
            return;
        }
        
        let query = PFQuery(className:"Record")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("date", equalTo:CFDate.getDateString(NSDate()))
        query.getFirstObjectInBackgroundWithBlock { (object:PFObject?, error:NSError?) in
            if (object != nil) {
                var goal = object!["goal"] as! Float;
                if (goal == 0) {
                    goal = CFStore.defaultGoal()
                }
                let notification = UILocalNotification()
                notification.fireDate = NSDate(timeIntervalSinceNow: 5)
                notification.alertBody = String(format: "Today's goal is %d steps", Int(goal*1000))
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                completion(success: true);
            } else {
                completion(success: false);
            }
        }
    }
}
