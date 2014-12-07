//
//  ViewController.swift
//  GymBuddy
//
//  Created by Justin Zhang on 11/26/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {
    
    @IBOutlet weak var netIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var myUsers:Array<User> = []
    let progressView = UIProgressView(progressViewStyle: .Bar)
    let myModel = LogInModel()

    @IBAction func logInButton(sender: AnyObject) {
        var netID = netIDTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var password = passwordTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if !netID.isEmpty && !password.isEmpty {
            myModel.searchForCredentials(self, netID:netID, password:password)
            progressView.center = view.center
            progressView.setProgress(0.5, animated: true)
            progressView.trackTintColor = UIColor.lightGrayColor()
            progressView.tintColor = UIColor.blueColor()
            view.addSubview(progressView)
        } else {
            progressView.setProgress(0.0, animated:false)
            progressView.removeFromSuperview()
            popUpAlertDialog("Alert", message: "Fill all the fields", buttonText: "OK")
        }
        netIDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        passwordTextField.secureTextEntry = true
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            if !fetchResults.isEmpty {
                var user:UserData = fetchResults[0]
                netIDTextField.text = user.net_id
                passwordTextField.text = user.password
            }
            for result in fetchResults {
                managedObjectContext?.deleteObject(result)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didGetQueryResult(resultList:Array<User>){
        myUsers = resultList
        if myUsers.isEmpty {
            progressView.setProgress(0.0, animated:false)
            progressView.removeFromSuperview()
            popUpAlertDialog("Alert", message: "Incorrect password or username", buttonText: "OK")
        } else {
            progressView.setProgress(1.0, animated: true)
            var user:User = resultList[0]
            let newUser = UserData.createInManagedObjectContext(self.managedObjectContext!, netID:user.net_id!, password:user.password!, firstName:user.first_name, lastName:user.last_name, gender:user.gender, pictureURL:user.picture_url, numThumbs:user.numb_thumb_ups, signature:user.signature)
            self.performSegueWithIdentifier("logInSuccess", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "logInSuccess") {
            var destinationVC = segue.destinationViewController as QueryViewController
        } else if (segue.identifier == "registration"){
            var destinationVC = segue.destinationViewController as RegistrationViewController
        }
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
}

