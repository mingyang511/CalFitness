//
//  AboutViewController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/8/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AboutViewController: UIViewController, UITextViewDelegate,MFMailComposeViewControllerDelegate
{
    
    var keyboardHeight = 0.0 as CGFloat
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextView.contentInset = UIEdgeInsetsMake(4,0.0,0,0.0);
        self.automaticallyAdjustsScrollViewInsets = false

        
        //Show
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AboutViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        //Hide
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AboutViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
        
        self.messageTextView.delegate = self
        self.messageTextView.returnKeyType = UIReturnKeyType.Done
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.messageTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if (textView.text.characters.count > 0)
        {
            placeHolderLabel.hidden = true;
        }
        else
        {
            placeHolderLabel.hidden = false;
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let height = screenSize.height-keyboardSize.origin.y
            UIView.animateWithDuration(duration,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: { _ in
                                        self.textViewBottomLayoutConstraint.constant = height + 60;
                                        self.sendButtonBottomLayoutConstraint.constant = height;
                    self.view.layoutIfNeeded()
                }, completion: { success in
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        if let keyboardSizeBegin = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            UIView.animateWithDuration(duration,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations:
                {
                    _ in
                    self.textViewBottomLayoutConstraint.constant = 60;
                    self.sendButtonBottomLayoutConstraint.constant = 0;
                    self.view.layoutIfNeeded()
                },
                completion:
                {
                    success in
            })
        }
    }
    
    @IBAction func sendPressed(sender: AnyObject)
    {
        print("sendPress")
        self.messageTextView.resignFirstResponder()
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["mzhou@berkeley.edu"])
        mailComposerVC.setSubject("Hello CalFit team")
        mailComposerVC.setMessageBody(self.messageTextView.text, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
        {
            (action) in
            //Empty closure
        }))
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
        if (error == nil)
        {
            messageTextView.text = ""
        }
    }
    
}
