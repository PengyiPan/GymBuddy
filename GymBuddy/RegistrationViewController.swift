//
//  RegistrationViewController.swift
//  GymBuddy
//
//  Created by Justin Zhang on 11/26/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var TitleTextField: UILabel!
    @IBOutlet weak var netIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    let progressView = UIProgressView(progressViewStyle: .Bar)
    let myModel = RegistrationModel()
    
    @IBAction func RegisterButton(sender: AnyObject) {
        var netID = netIDTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var password = passwordTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var rePassword = rePasswordTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if !netID.isEmpty && !password.isEmpty && !rePassword.isEmpty {
            if(password != rePassword){
                popUpAlertDialog("Alert", message: "Password not matched", buttonText: "OK")
            } else {
                //TODO:send registration info to database
                myModel.postCredentials(self, netID: netID, password: password)
                progressView.center = view.center
                progressView.setProgress(0.5, animated: true)
                progressView.trackTintColor = UIColor.lightGrayColor()
                progressView.tintColor = UIColor.blueColor()
                view.addSubview(progressView)
            }
        } else {
            popUpAlertDialog("Alert", message: "Fill all the fields", buttonText: "OK")
        }
    }
    
    func didGetPostResult(message:String){
        progressView.setProgress(1.0, animated: true)
        //check if registered successfully
        
    }
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    func popUpAlertDialog(alert:String, message:String, buttonText:String){
        var alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

