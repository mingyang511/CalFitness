//
//  ResetPasswordViewController.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backButton.layer.cornerRadius = 5;
        self.backButton.layer.borderColor = UIColor.init(colorLiteralRed: 14/255.0, green: 122/255.0, blue: 1, alpha: 1).CGColor;
        self.backButton.layer.borderWidth = 1;
        self.resetButton.layer.cornerRadius = 5;
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
//        self.emailTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetButtonTapped(sender: AnyObject)
    {
        let email = self.emailTextField.text
        if (email == nil || !CFAuthHelper.sharedInstance.isValidEmail(email!))
        {
            CFAlertHelper.showAlert("Invalid email", message: "Please input a valid email address", controller: self)
            return 
        }
        
        self.emailTextField.resignFirstResponder()
        
        CFAuthHelper.sharedInstance.performUserResetPassword(email!)
        {
            (success, error) in
            
            if (success)
            {
                CFAlertHelper.showAlert("Successful", message: "An email has been sent to your inbox. Please check.", controller: self)
                
            }
            else
            {
                CFAlertHelper.showAlert("Error", message: (error?.description)!, controller: self)
            }
        }
    }
    
    @IBAction func backButtonTapped(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
