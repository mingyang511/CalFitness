//
//  HistoryViewController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/1/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Parse
import Bolts

class HistoryViewController: UIViewController
{
    var graph: Graph!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateViewWithRecordsFromLocal()
    }
    
    @IBAction func UploadData(sender: AnyObject)
    {
        self.updateViewWithRecordsFromHealthKit()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.updateViewWithRecordsFromServer()
    }
    
    func updateViewWithRecordsFromHealthKit()
    {
        self.spinner.startAnimating()
        self.updateButton.userInteractionEnabled = false;
        
        CFHealthKitHelper.sharedInstance.fetchLastWeekRecordsFromHealthKit(
        {
            (success, records) in
            CFRecordManager.saveLastWeekRecordsToServer(records, completion:
            {
                (success, records) in
                self.updateView(records)
                self.spinner.stopAnimating()
                self.updateButton.userInteractionEnabled = true;
            })
        })
    }
    
    func updateViewWithRecordsFromLocal()
    {
        let records = CFRecordManager.fetchLastWeekRecordsFromLocal()
        dispatch_async(dispatch_get_main_queue(),
        {
            self.updateView(records)
        })
    }
    
    func updateViewWithRecordsFromServer()
    {
        CFRecordManager.fetchLastWeekRecordsFromServer
        {
            (success, records) in
            
            dispatch_async(dispatch_get_main_queue(),
            {
                self.updateView(records)
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func updateView(records:[CFRecord])
    {
        var recordsToDisplay = [CFRecord]()
        let today = NSDate()
        for i in 1 ... 7
        {
            let dayBefore = today.dateByAddingTimeInterval(-Double(7-i)*24 * 60 * 60)
            let recordToDisplay = CFRecord()
            recordToDisplay.date = CFDateHelper.getDateString(dayBefore)
            recordToDisplay.step = 0
            recordToDisplay.goal = 0
            recordsToDisplay.append(recordToDisplay)
        }
        
        var indexRecords = 0
        var indexRecordsToDisplay = 0
        
        while (indexRecordsToDisplay < recordsToDisplay.count && indexRecords < records.count)
        {
            let record = records[indexRecords]
            let recordToDisplay = recordsToDisplay[indexRecordsToDisplay]
            
            if (record.date == recordToDisplay.date)
            {
                recordToDisplay.step = record.step
                recordToDisplay.goal = record.goal
                
                indexRecords += 1
                indexRecordsToDisplay += 1
            }
            else if (record.date < recordToDisplay.date)
            {
                indexRecords += 1
            }
            else
            {
                indexRecordsToDisplay += 1
            }
        }
        
        //Get screen sizes
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // Create graph view
        let graphView: Graph = Graph(frame:CGRectMake(20, 140, screenWidth - 40, screenHeight - 160), records:records)
        self.view.addSubview(graphView)
        if !(self.graph == nil)
        {
            self.graph.removeFromSuperview()
        }
        self.graph = graphView
    }
}
