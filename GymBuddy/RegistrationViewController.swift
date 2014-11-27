//
//  RegistrationViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var TitleTextField: UILabel!
    @IBOutlet weak var netIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    @IBAction func RegisterButton(sender: AnyObject) {
        if !netIDTextField.text.isEmpty && !passwordTextField.text.isEmpty && !rePasswordTextField.text.isEmpty {
            if(passwordTextField.text != rePasswordTextField.text){
                popUpAlertDialog("Alert", message: "Password not matched", buttonText: "OK")
                return;
            }
            //send registration info to database
            
        } else {
            popUpAlertDialog("Alert", message: "Fill all the fields", buttonText: "OK")
        }
    }
    
    func popUpAlertDialog(alert:String, message:String, buttonText:String){
        var alert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

