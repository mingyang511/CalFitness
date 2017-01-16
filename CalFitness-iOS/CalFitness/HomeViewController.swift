//
//  HomeViewController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/1/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import UIKit
import Parse
import Bolts

class HomeViewController: UIViewController, CFHealthDelegate
{
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var stepsTodayLabel: LTMorphingLabel!
    @IBOutlet weak var goalTodayLabel: LTMorphingLabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set up buttons images
        self.historyButton.setImage(UIImage(named:"graph.png"), forState: .Normal)
        self.historyButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.historyButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        self.infoButton.setImage(UIImage(named:"info.png"), forState: .Normal)
        self.infoButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.infoButton.imageEdgeInsets = self.historyButton.imageEdgeInsets 
        
        //Navigation View Controller title colors
        self.navigationController!.navigationBar.tintColor = UIColor(red: 6/255.0, green: 29/255.0, blue: 65/255.0, alpha: 1.0)
        
        CFNotificationCenterHelper.addApplicationWillEnterForegroundObserver(self, selector: #selector(updateRecord))
    }
    
    override func viewWillAppear(animated: Bool)
    {
        CFHealthKitHelper.sharedInstance.delegate = self
        updateRecord()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func updateRecord()
    {
        if (PFUser.currentUser() == nil)
        {
            // Not logged in
            self.updateView(0, goal: 0)
        }
        else
        {
            // Logged in
            CFHealthKitHelper.sharedInstance.fetchTodayRecordFromHealthKit(
            {
                (success, record) in
                if (record == nil)
                {
                    self.updateView(0, goal: 0)
                }
                else
                {
                    self.updateView(Int(record!.step), goal: 0)
                    CFRecordManager.saveRecord(record!, completion:
                    {
                        (success, record) in
                         self.updateView(Int(record.step), goal: Int(record.goal))
                    })
                }
            })
        }
    }
    
    func updateView(step: Int, goal:Int)
    {
        stepsTodayLabel.morphingEffect = .Evaporate
        goalTodayLabel.morphingEffect = .Evaporate
        stepsTodayLabel.text = String(step)
        
        if (goal <= 0)
        {
            goalTodayLabel.text = "NA"
        }
        else
        {
            goalTodayLabel.text = String(goal)
        }
    }
}
