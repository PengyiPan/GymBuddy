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

class FirstNameEditViewController:UIViewController {
    
    var myEditThing:EditAttribute = EditAttribute.EditFirstName
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    @IBAction func saveButton(sender: AnyObject) {
        //TODO
        self.performSegueWithIdentifier("backToProfileSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNavigationTitle()
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0]
            textField.text = user.first_name
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
    
    enum EditAttribute {
        case EditFirstName
        case EditLastName
        case EditSignature
    }
    
}

