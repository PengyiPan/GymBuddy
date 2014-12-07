//
//  FirstNameEditViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/29/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfileEditViewController:UIViewController {
    
    var myEditThing:EditAttribute = EditAttribute.EditFirstName
    let progressView = UIProgressView(progressViewStyle: .Bar)
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    @IBAction func saveButton(sender: AnyObject) {
        var content = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if !content.isEmpty {
            var netID:String = ""
            let fetchRequest = NSFetchRequest(entityName: "UserData")
            if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
                var user:UserData = fetchResults[0];
                netID = user.net_id
            }
            
            ProfileUpdateModel.updateUserProfile(self, netID: netID, attributeContent: content, attributeType: myEditThing)
            progressView.center = view.center
            progressView.setProgress(0.5, animated: true)
            progressView.trackTintColor = UIColor.lightGrayColor()
            progressView.tintColor = UIColor.blueColor()
            view.addSubview(progressView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNavigationTitle()
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0]
            switch myEditThing {
            case EditAttribute.EditFirstName:
                textField.text = user.first_name
            case EditAttribute.EditLastName:
                textField.text = user.last_name
            case EditAttribute.EditSignature:
                textField.text = user.signature
                textField.placeholder = "You may leave contact information here"
            default:
                textField.text = ""
            }
        }
    }
    
    func displayNavigationTitle() {
        switch myEditThing {
        case EditAttribute.EditFirstName:
            navigationLabel.title = "First Name"
        case EditAttribute.EditLastName:
            navigationLabel.title = "Last Name"
        case EditAttribute.EditSignature:
            navigationLabel.title = "Signature"
        default:
            navigationLabel.title = ""
        }
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func didGetPostResult(result:UpdateResult, attributeContent:String, attributeType:EditAttribute){
        switch  result {
        case UpdateResult.Success:
            let fetchRequest = NSFetchRequest(entityName: "UserData")
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
                var user:UserData = fetchResults[0]
                switch attributeType {
                case EditAttribute.EditFirstName:
                    user.first_name = attributeContent
                case EditAttribute.EditLastName:
                    user.last_name = attributeContent
                case EditAttribute.EditSignature:
                    user.signature = attributeContent
                default:
                    break
                }
            }
            progressView.setProgress(1.0, animated: true)
            self.performSegueWithIdentifier("backToProfileSegue", sender: self)
        case UpdateResult.Failure:
            break
        }
    }
    
}

