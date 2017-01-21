//
//  CFAuthHelper.swift
//  CalFitnesss
//
//  Created by Lee on 1/15/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse 

class CFAuthHelper
{
    static let sharedInstance = CFAuthHelper()
    
    func isLoggedIn() -> Bool
    {
        return (CFUser.currentUser() != nil)
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isPssswordEmail(testStr:String) -> Bool
    {
        let passwordRegEx = "(?=.*[0-9]).{6}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(testStr)
    }
    
    func performUserAuth()
    {
        let appDelegate = UIApplication.sharedApplication().delegate
        
        if (!self.isLoggedIn())
        {
            appDelegate!.window?!.rootViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Login")
        }
        else
        {
            CFHealthKitHelper.sharedInstance.authorizeHealthKit({ (success, error) in })
            
            appDelegate!.window!!.rootViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Home");
        }
        
        appDelegate!.window?!.makeKeyAndVisible();
    }
    
    func performUserSignIn(email:String, password:String, completion:(success:Bool, error:NSError?) -> Void)
    {
        SVProgressHUD.show()
        
        CFUser.logInWithUsernameInBackground(email, password: password)
        {
            (user, error) in
            
            SVProgressHUD.dismiss()
            
            completion(success: !(user==nil), error: error)
        }
    }
    
    func performUserSignUp(email:String, password:String, completion:(success:Bool, error:NSError?) -> Void)
    {
        SVProgressHUD.show()
        
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user.signUpInBackgroundWithBlock
        {
            (succeeded: Bool, error: NSError?) -> Void in
            
            SVProgressHUD.dismiss()
            
            completion(success: succeeded, error: error)
        }
    }
    
    func performUserResetPassword(email:String, completion:(success:Bool, error:NSError?) -> Void)
    {
        SVProgressHUD.show()
        
        CFUser.requestPasswordResetForEmailInBackground(email)
        {
            (success, error) in
            
            SVProgressHUD.dismiss()
            
            completion(success: success, error: error)
        }
    }
    
    func performUserSignOut(completion:(success:Bool, error:NSError?) -> Void)
    {
        SVProgressHUD.show()
        
        let appDelegate = UIApplication.sharedApplication().delegate
        
        if (self.isLoggedIn())
        {
            PFUser.logOutInBackgroundWithBlock(
            {
                (error) in
                
                CFRecordManager.cleanAllRecords()
                
                appDelegate!.window?!.rootViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Login")
                appDelegate!.window?!.makeKeyAndVisible();
                
                SVProgressHUD.dismiss()
                
                completion(success: true, error: error)
            })
        }
        else
        {
            appDelegate!.window?!.rootViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Login")
            appDelegate!.window?!.makeKeyAndVisible();
            
            SVProgressHUD.dismiss()
            
            completion(success: true, error: nil)
        }
    }
    
    func performHealthKitAuthVerification(completion:(success:Bool, error:NSError?) -> Void)
    {
        SVProgressHUD.show()

        CFHealthKitHelper.sharedInstance.authorizeHealthKit
        {
            (authorized,  error) -> Void in
            
            SVProgressHUD.dismiss()
            
            completion(success: authorized, error: error)
        }
        
    }
    
    func userAuthCompleted()
    {
        SVProgressHUD.show()
        
        dispatch_async(dispatch_get_main_queue(),
        {
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate!.window!!.rootViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Home");
            
            appDelegate!.window?!.makeKeyAndVisible();
            
            SVProgressHUD.dismiss()
        })
    }
}
