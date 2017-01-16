//
//  HealthController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/22/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import HealthKit
import Parse
import Bolts

protocol CFHealthDelegate
{
    func updateView(steps: Int, goal:Int)
}

class CFHealthController
{
    var delegate: CFHealthDelegate?
    var authorized: Bool = false
    
    let uuid = NSUUID().UUIDString
    let healthStore = HKHealthStore()
   
    let readDataTypes: Set<HKObjectType> = [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!]
    let writeDataTypes: Set<HKSampleType> = []
    
    static let sharedInstance = CFHealthController()
    
    private init() {}
 
    // Method to request HealthKit authorization
    func authorizeHealthKit(completion: ((success:Bool, error:NSError?) -> Void)!)
    {
        healthStore.requestAuthorizationToShareTypes(writeDataTypes, readTypes: readDataTypes)
        {
            (success: Bool, error: NSError?) -> Void in
            
            if (completion != nil)
            {
                completion(success:success,error:error)
            }
            
            if (success)
            {
                self.authorized = true
                self.fetchRecordsOfPastWeek(
                {
                    (success) in
                    completion(success: success, error: error)
                })
            }
        }
    }
    
    // Method to fetch health records within the duration
    func fetchRecordsFromHealthKit(startDate:NSDate, endDate:NSDate, completion:(success:Bool, records:NSArray) -> Void)
    {
        if(!authorized)
        {
            return
        }
        
        let days = Int(endDate.timeIntervalSinceDate(startDate)/(3600*24))
        let records = NSMutableArray()
        let nameFormatter  = NSDateFormatter()
        
        nameFormatter.dateFormat = "MM/dd/yy"
        
        let today = NSDate()
        for i in 0 ... days
        {
            let dayBefore = today.dateByAddingTimeInterval(-Double(days-i)*24 * 60 * 60)
            let day = nameFormatter.stringFromDate(dayBefore)
            records.addObject([0.0, dayBefore, day])
        }
        
        let limit = 1000
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .StrictStartDate)
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let stepsSampleQuery = HKSampleQuery(sampleType: stepsCount!, predicate: predicate, limit: limit, sortDescriptors: nil)
        {
            (sampleQuery, results, error ) -> Void in
            
            if let results = results as? [HKQuantitySample]
            {
                print(results.count)
                for result in results
                {
                    let nameFormatter  = NSDateFormatter()
                    nameFormatter.dateFormat = "MM/dd/yy"
                    let day = nameFormatter.stringFromDate(result.startDate)
                    
                    for i in  0...records.count-1
                    {
                        let element = records[i] as! NSArray
                        if(element[2] as! String == day)
                        {
                            let oldNumber: Float = element[0] as! Float
                            let fullName = String(result.quantity)
                            let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                            let numberString: String = fullNameArr[0]
                            let number: Float = (numberString as NSString).floatValue
                            let newNumber: Float = oldNumber + number
                            records[i] = [newNumber, result.startDate, day]
                        }
                    }
                }
                completion(success: true, records: records)
            }
            else
            {
                completion(success: false, records: NSArray())
            }
        }
        
        healthStore.executeQuery(stepsSampleQuery)
    }
    
    // Method to fetch health record of today
    func fetchRecordOfToday(background:Bool, completion:(success:Bool) -> Void)
    {
        self.fetchRecordsFromHealthKit((PFUser.currentUser() != nil),
                                       fetchAllFromServerAfterSaving: (PFUser.currentUser() != nil) && !background,
                                       startDate: CFDateHelper.beginningOfToday(),
                                       endDate: NSDate(),
                                       completion: { (success) in completion(success: success)})
    }
    
    // Method to fetch health records of the past week
    func fetchRecordsOfPastWeek(completion:(success:Bool) -> Void)
    {
        self.fetchRecordsFromHealthKit((PFUser.currentUser() != nil),
                                       fetchAllFromServerAfterSaving: (PFUser.currentUser() != nil),
                                       startDate: CFDateHelper.beginningOfDate(NSDate().dateByAddingTimeInterval(-3600*24*6)),
                                       endDate: NSDate(),
                                       completion: { (success) in completion(success: success)})
    }
    
    // Method to fetch health records within the duration and save to the server
    func fetchRecordsFromHealthKit(saveToServer:Bool, fetchAllFromServerAfterSaving:Bool, startDate:NSDate, endDate:NSDate, completion:(success:Bool) -> Void)
    {
        self.fetchRecordsFromHealthKit(startDate, endDate:endDate)
        {
            (success, records) in
            
            if records.count > 0
            {
                dispatch_async(dispatch_get_main_queue(),
                {
                    if let delegate = self.delegate
                    {
                        let index = records.count-1 > 0 ? records.count-1 : 0
                        let steps = (records[index] as! NSArray)[0] as! Int
                        let goal = Int(CFRecordManager.getGoalForToday()*1000)
                        
                        delegate.updateView(steps, goal:goal)
                    }
                    
                    if (saveToServer)
                    {
                        self.uploadRecords(records, completion:
                        {
                            (success) in
                            
                            if (fetchAllFromServerAfterSaving)
                            {
                                CFRecordManager.fetchRecordsFromServerInBackground({(success, objects) in
                                    completion(success: success)
                                })
                            }
                            else
                            {
                                completion(success: success)
                            }
                        });
                    }
                    else
                    {
                        completion(success: success)
                    }
                })
            }
            else
            {
                completion(success: success)
            }
        }
    }
    
    // Method to upload record to server
    func uploadRecords(records:NSArray, completion:(success:Bool) -> Void)
    {
        for i in 0 ... records.count-1
        {
            let steps = ((records[i] as! NSArray)[0] as! Double)/1000.0
            let date = (records[i] as! NSArray)[1] as! NSDate
            CFRecordManager.saveNewRecord(steps, date: date, completion:
            {
                (success, goal, date) in
                
                if (CFDateHelper.getDateString(date).isEqualToString(CFDateHelper.getDateString(NSDate()) as String))
                {
                    if let delegate = self.delegate
                    {
                        delegate.updateView(Int(steps * 1000), goal:Int(goal * 1000))
                    }
                }
                
                if i == records.count-1
                {
                    completion(success: success)
                }
            });
        }
    }
}
