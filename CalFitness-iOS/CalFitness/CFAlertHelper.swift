//
//  CFAlertHelper.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class CFAlertHelper
{
    class func showAlert(title:String, message:String, controller:UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
