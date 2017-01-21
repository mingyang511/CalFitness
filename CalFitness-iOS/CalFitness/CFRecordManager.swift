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
    // Method to create new record
    class func createRecord(step:Int, date:String) -> CFRecord
    {
        let record = CFRecord()
        record.step = step;
        record.date = date;
        record.goal = -1
        record.user = PFUser.currentUser();
        return record;
    }
    
    // Method to create new record
    class func createRecord(step:Int, goal:Int, date:String) -> CFRecord
    {
        let record = CFRecord()
        record.step = step;
        record.date = date;
        record.goal = goal;
        record.user = PFUser.currentUser();
        return record;
    }
    
    //********
    // Server
    //********

    // Method to fectch records from server in background
    class func fetchLastWeekRecordsFromServer(completion:(success:Bool, records:[CFRecord]) -> Void)
    {
        if (CFUser.currentUser() == nil)
        {
            completion(success: false, records: [CFRecord]());
            return
        }
        
        let query = PFQuery(className:"Record")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("date", greaterThanOrEqualTo: CFDateHelper.getDateString(NSDate().dateByAddingTimeInterval(-7 * 24 * 60 * 60)))
        query.whereKey("date", lessThanOrEqualTo: CFDateHelper.getDateString(NSDate()))
        query.orderByDescending("date")
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) in
            
            if (objects != nil && objects!.count > 0)
            {
                saveLastWeekRecordsToLocal(objects as! [CFRecord])
                completion(success: false, records: objects as! [CFRecord]);
            }
            else
            {
                completion(success: false, records: createEmptyLastWeekRecords());
            }
        }
    }

    // Method to fectch record from server in background
    class func fetchTodayRecordFromServer(completion:(success:Bool, record:CFRecord?) -> Void)
    {
        if (CFUser.currentUser() == nil)
        {
            completion(success: false, record: nil);
            return
        }
        
        let query = PFQuery(className:"Record")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("date", equalTo: CFDateHelper.getDateString(NSDate()))
        query.getFirstObjectInBackgroundWithBlock(
        {
            (object: PFObject?, error: NSError?) in
            
            if (object != nil)
            {
                saveTodayRecordToLocal(object as! CFRecord)
                completion(success: false, record: object as? CFRecord);
            }
            else
            {
                completion(success: false, record: nil);
            }
        })
    }

    // Method to create new record and save to server
    class func saveTodayRecordToServer(step:Int, date:String, completion:(success:Bool, record: CFRecord) -> Void)
    {
        // Create new record
        let record = createRecord(step, date:date)
        
        saveTodayRecordToServer(record)
        {
            (success, record) in
            completion(success: success, record: record)
        }
    }
    
    // Method to save existing record to server
    class func saveTodayRecordToServer(record: CFRecord, completion:(success:Bool, record: CFRecord) -> Void)
    {
        // Save record in background and retrieve goal
        record.saveInBackgroundWithBlock
        {
            (success:Bool, error:NSError?) in
            saveTodayRecordToLocal(record)
            completion(success: success, record: record)
        }
    }
    
    class func saveLastWeekRecordsToServer(records:[CFRecord], completion:(success:Bool, records: [CFRecord]) -> Void)
    {
        CFRecord.saveAllInBackground(records)
        {
            (success:Bool, error:NSError?) in
            saveLastWeekRecordsToLocal(records)
            completion(success: success, records: records)
        }
    }

    //*******
    // Local
    //*******
    
    // Method
    class func fetchLastWeekRecordsFromLocal() -> [CFRecord]
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let rawRecords = userDefaults.objectForKey("LastWeekRecord")
        var records = [CFRecord]()
        
        if (rawRecords != nil)
        {
            for rawRecord in rawRecords as! [CFRecord]
            {
                let record = CFRecordManager.createRecord(rawRecord["step"] as! Int,
                                                          goal: rawRecord["goal"] as! Int,
                                                          date: rawRecord["date"] as! String)
                records.append(record)
            }
        }
        else
        {
            records = createEmptyLastWeekRecords()
        }

        records = records.sort({ record1, record2 in return record1.date < record2.date })
        
        return records
    }

    class func fetchTodayRecordFromLocal() -> CFRecord?
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let rawRecord = userDefaults.objectForKey("TodayRecord")
        var record = CFRecordManager.createEmptyTodayRecord()
        
        if (rawRecord != nil)
        {
            let rawRecord = rawRecord as! NSDictionary
            record = CFRecordManager.createRecord(rawRecord["step"] as! Int,
                                                  goal: rawRecord["goal"] as! Int,
                                                  date: rawRecord["date"] as! String)
        }
        else
        {
            record = createEmptyTodayRecord()
        }
        
        return record
    }
    
    private class func saveLastWeekRecordsToLocal(records: [CFRecord])
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var rawRecords = [NSDictionary]()
        
        for record in records
        {
            let rawRecord = ["date": record.date, "step": record.step, "goal": record.goal]
            rawRecords.append(rawRecord)
        }
        
        userDefaults.setObject(rawRecords, forKey: "LastWeekRecords")
    }
    
    private class func saveTodayRecordToLocal(record: CFRecord)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let todayString = CFDateHelper.getDateString(NSDate())
        
        if (record.date == todayString)
        {
            let rawRecord = ["date": record.date, "step": record.step, "goal": record.goal]
            userDefaults.setObject(rawRecord, forKey: "TodayRecord")
        }
    }
    
    class func cleanAllRecords()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("TodayRecord")
        userDefaults.removeObjectForKey("LastWeekRecords")
    }
    
    class func createEmptyLastWeekRecords() -> [CFRecord]
    {
        var records = [CFRecord]()
        let today = NSDate()
        
        for i in 1 ... 7
        {
            let dayBefore = today.dateByAddingTimeInterval(-Double(7-i)*24 * 60 * 60)
            let record = CFRecordManager.createRecord(0, date: CFDateHelper.getDateString(dayBefore))
            records.append(record)
        }
        
        return records
    }
    
    class func createEmptyTodayRecord() -> CFRecord
    {
        let record = CFRecordManager.createRecord(0, date: CFDateHelper.getDateString(NSDate()))
        return record
    }
}
