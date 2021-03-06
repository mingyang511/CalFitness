//
//  CFTaskManager.swift
//  CalFitnesss
//
//  Created by Lee on 1/16/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation

class CFTaskManager
{
    class func uploadTodayRecord(completion:(success:Bool) -> Void)
    {
        if (CFUser.currentUser() != nil)
        {
            CFHealthKitHelper.sharedInstance.fetchTodayRecordFromHealthKit(
            {
                (success, record) in
                if (record != nil)
                {
                    CFRecordManager.saveTodayRecordToServer(record!, completion:
                    {
                        (success, record) in
                        completion(success: success)
                    })
                }
                completion(success: false)
            })
        }
        completion(success: false)
    }
    
    class func uploadLastWeekRecords(completion:(success:Bool) -> Void)
    {
        if (CFUser.currentUser() != nil)
        {
            CFHealthKitHelper.sharedInstance.fetchLastWeekRecordsFromHealthKit(
            {
                (success, records) in
                CFRecordManager.saveLastWeekRecordsToServer(records, completion:
                {
                    (success, records) in
                    completion(success: success)
                })
            })
        }
        completion(success: false)
    }
}
