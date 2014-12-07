//
//  EditPasswordViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/7/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditPasswordViewController:UIViewController {
    
    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var reNewPassField: UITextField!
    let progressView = UIProgressView(progressViewStyle: .Bar)
    @IBAction func saveButton(sender: AnyObject) {
        var netID:String = ""
        var currentPassword:String = ""
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            netID = user.net_id
            currentPassword = user.password
        }
        var oldPassword = oldPassField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var newPassword = newPassField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var reNewPassword = reNewPassField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if (!validatePassword(newPassword)){
            popUpAlertDialog("Alert", message: "Password length need to be between 5 to 10 characters", buttonText: "Ok")
        } else if(oldPassword != currentPassword){
            popUpAlertDialog("Alert", message: "Old password not correct", buttonText: "Ok")
        } else if (oldPassword == newPassword){
            popUpAlertDialog("Alert", message: "New password and old password cannot be the same", buttonText: "Ok")
        } else if (newPassword != reNewPassword) {
            popUpAlertDialog("Alert", message: "New passwords not matched", buttonText: "Ok")
        } else {
            ProfileUpdateModel.updatePassword(self, netID: netID, password: newPassword)
            progressView.center = view.center
            progressView.setProgress(0.5, animated: true)
            progressView.trackTintColor = UIColor.lightGrayColor()
            progressView.tintColor = UIColor.blueColor()
            view.addSubview(progressView)
        }
        
        
    }
    
    func validatePassword(password:String) -> Bool {
        if countElements(password) < 5 || countElements(password) > 10 {
            return false
        } 
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPassField.secureTextEntry = true
        newPassField.secureTextEntry = true
        reNewPassField.secureTextEntry = true
    }
    
    func popUpAlertDialog(alert:String, message:String, buttonText:String){
        var alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func didGetPostResult(result:UpdateResult, password:String) {
        switch result {
        case UpdateResult.Success:
            let fetchRequest = NSFetchRequest(entityName: "UserData")
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
                var user:UserData = fetchResults[0]
                user.password = password
            }
            progressView.setProgress(1.0, animated: true)
            self.performSegueWithIdentifier("backToProfileSegue", sender: self)
        case UpdateResult.Failure:
            break
        }
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
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

}