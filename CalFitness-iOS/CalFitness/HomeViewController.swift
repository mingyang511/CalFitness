
//  HomeViewController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/1/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import UIKit
import Parse
import Bolts

class HomeViewController: UIViewController
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
        
        self.stepsTodayLabel.morphingEffect = .Evaporate
        self.goalTodayLabel.morphingEffect = .Evaporate
        
        //Navigation View Controller title colors
        self.navigationController!.navigationBar.tintColor = UIColor(red: 6/255.0, green: 29/255.0, blue: 65/255.0, alpha: 1.0)
        
        CFNotificationCenterHelper.addApplicationWillEnterForegroundObserver(self, selector: #selector(updateRecord))
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if(CFAuthHelper.sharedInstance.isLoggedIn())
        {
            updateRecord()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func signOutButtonTapped(sender: AnyObject)
    {
        CFAuthHelper.sharedInstance.performUserSignOut({ (success, error) in })
    }
    
    func updateRecord()
    {
        if (PFUser.currentUser() == nil)
        {
            // Not logged in
            self.updateStepLabel(0)
            self.updateGoalLabel(0)
        }
        else
        {
            // Logged in
            let cachedRecord = CFRecordManager.fetchTodayRecordFromLocal()
            
            if (cachedRecord != nil)
            {
                dispatch_async(dispatch_get_main_queue(),
                {
                    self.updateStepLabel(Int(cachedRecord!.step))
                    self.updateGoalLabel(Int(cachedRecord!.goal))
                })
            }
            
            CFHealthKitHelper.sharedInstance.fetchTodayRecordFromHealthKit(
            {
                (success, record) in
                if (record != nil)
                {
                    self.updateStepLabel(Int(record!.step))
                    CFRecordManager.saveTodayRecordToServer(record!, completion:
                    {
                        (success, record) in
                        dispatch_async(dispatch_get_main_queue(),
                        {
                            self.updateGoalLabel(Int(record.goal))
                        })
                    })
                }
            })
        }
    }
    
    func updateStepLabel(step: Int)
    {
        stepsTodayLabel.text = String(step)
    }
    
    func updateGoalLabel(goal:Int)
    {
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
