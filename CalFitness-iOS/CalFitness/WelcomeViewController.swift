//
//  WelcomeViewController.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController
{
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.signUpButton.layer.cornerRadius = 5;
        self.signUpButton.layer.borderColor = UIColor.init(colorLiteralRed: 14/255.0, green: 122/255.0, blue: 1, alpha: 1).CGColor;
        self.signUpButton.layer.borderWidth = 1;
        self.signInButton.layer.cornerRadius = 5;
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
