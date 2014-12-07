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
    
    func didGetPostResult(code:RegistrationModel.RegisterResult, user:User){
        if code == RegistrationModel.RegisterResult.RegisterSuccess {
            progressView.setProgress(1.0, animated: true)
            deleteUserData()
            let newUser = UserData.createInManagedObjectContext(self.managedObjectContext!, netID: user.net_id!, password: user.password!, picture: user.picture_url!)
            self.performSegueWithIdentifier("registerSuccess", sender: self)
        } else {
            progressView.setProgress(0.0, animated: false)
            progressView.removeFromSuperview()
            
            if code == RegistrationModel.RegisterResult.NonValidPassword {
                popUpAlertDialog("NonValid Password", message: "Password must be longer than 5 and shorter than 10 (inclusive)", buttonText: "OK")
            } else if code == RegistrationModel.RegisterResult.AlreadyExists {
                popUpAlertDialog("NetID Already Exists", message: "Change NetID or Login With Password", buttonText: "OK")
            }
        }
    }
    
    func deleteUserData() {
        NSLog("User Credentials in CoreData Deleted")
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            for result in fetchResults {
                managedObjectContext?.deleteObject(result)
            }
        }
    }
    
    func popUpAlertDialog(alert:String, message:String, buttonText:String){
        var alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

