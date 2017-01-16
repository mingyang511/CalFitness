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
    }
    
    @IBAction func UploadData(sender: AnyObject)
    {
        self.spinner.startAnimating()
        self.updateButton.userInteractionEnabled = false;
        self.updateViewWithRecords()
        
        CFHealthKitHelper.sharedInstance.fetchRecordsOfPastWeek(
        {
            (success) in
            
            self.updateViewWithRecords()
            self.spinner.stopAnimating()
            self.updateButton.userInteractionEnabled = true;
        })
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.updateViewWithRecords()
    }
    
    func updateViewWithRecords()
    {
        CFRecordManager.getRecordsForLastWeek
        {
            (success, objects) in
            let records = NSMutableArray()
            if (objects!.count < 7)
            {
                for i in 0 ... (6 - (objects!.count))
                {
                    records.addObject([Float(0),CFDateHelper.beginningOfDate(NSDate().dateByAddingTimeInterval(3600*24*Double(i-6)))])
                }
            }

            if !(objects==nil) && (objects?.count>0)
            {
                for i in 0 ... objects!.count-1
                {
                    let object = objects![i]
                    records.addObject([
                        object["step"].floatValue * 1000,
                        CFDateHelper.getDate(object["date"] as? String)
                        ])
                }
            }
            
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
    
    func updateView(records:NSArray)
    {
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
