//
//  SignupViewController.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    var completionHandler: ((Bool, NSError) -> Void)?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.backButton.layer.cornerRadius = 5;
        self.backButton.layer.borderColor = UIColor.init(colorLiteralRed: 14/255.0, green: 122/255.0, blue: 1, alpha: 1).CGColor;
        self.backButton.layer.borderWidth = 1;
        self.signUpButton.layer.cornerRadius = 5;
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
//        self.emailTextField.becomeFirstResponder()
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject)
    {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        
        if (email == nil || !CFAuthHelper.sharedInstance.isValidEmail(email!))
        {
            CFAlertHelper.showAlert("Invalid email", message: "Please input a valid email address", controller: self)
            return
        }
        
        if (password == nil || !CFAuthHelper.sharedInstance.isPssswordEmail(password!))
        {
            CFAlertHelper.showAlert("Invalid email", message: "Please input a valid 6-digit password", controller: self)
            return
        }
        
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        CFAuthHelper.sharedInstance.performUserSignUp(email!, password: password!)
        {
            (success, error) in
            
            if (success)
            {
                self.performSegueWithIdentifier("SignUp2HKAuth", sender: self)
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
