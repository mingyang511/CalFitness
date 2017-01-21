//
//  SignInViewController.swift
//  CalFitnesss
//
//  Created by Lee on 1/21/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate
{
    var completionHandler: ((Bool, NSError) -> Void)?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.backButton.layer.cornerRadius = 5;
        self.backButton.layer.borderColor = UIColor.init(colorLiteralRed: 14/255.0, green: 122/255.0, blue: 1, alpha: 1).CGColor;
        self.backButton.layer.borderWidth = 1;
        self.signInButton.layer.cornerRadius = 5;
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
    
    @IBAction func signInButtonTapped(sender: AnyObject)
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
        
        CFAuthHelper.sharedInstance.performUserSignIn(email!, password: password!)
        {
            (success, error) in
            
            if (success)
            {
                self.performSegueWithIdentifier("SignIn2HKAuth", sender: self)
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
