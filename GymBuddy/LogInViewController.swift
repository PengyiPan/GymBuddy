//
//  ViewController.swift
//  GymBuddy
//
//  Created by Justin Zhang on 11/26/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

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
    
    func popUpAlertDialog(alert:String, message:String, buttonText:String){
        var alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didGetQueryResult(resultList:Array<User>){
        myUsers = resultList
        progressView.setProgress(1.0, animated: true)
        if myUsers.isEmpty {
            progressView.setProgress(0.0, animated:false)
            progressView.removeFromSuperview()
            popUpAlertDialog("Alert", message: "Password not correct", buttonText: "OK")
        } else {
            self.performSegueWithIdentifier("logInSuccess", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "logInSuccess") {
            var destinationVC = segue.destinationViewController as QueryViewController
            //TODO: pass netID to views
            //destinationVC.receivedQueryTime = self.labelTextToOutputText(timeDisplayLabel.text!)
        } else if (segue.identifier == "registration"){
            var destinationVC = segue.destinationViewController as RegistrationViewController
        }
    }

}

