//
//  HeathKitAuthViewController.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class HealthKitAuthViewController: UIViewController
{
    @IBOutlet weak var authorizeButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.authorizeButton.layer.cornerRadius = 5;
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func authorizeButtonTapped(sender: AnyObject)
    {
        CFAuthHelper.sharedInstance.performHealthKitAuthVerification
        {
            (success, error) in
            
            if (success)
            {
                CFTaskManager.uploadLastWeekRecords({ (success) in })
                CFAuthHelper.sharedInstance.userAuthCompleted()
            }
            else
            {
                CFAlertHelper.showAlert("Error", message: (error?.description)!, controller: self)
            }
        }
    }
}
