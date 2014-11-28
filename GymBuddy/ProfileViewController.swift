//
//  ProfileViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/27/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController{
    
    @IBAction func logOutButton(sender: AnyObject) {
        println("User Credentials in CoreData Deleted")
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            for result in fetchResults {
                managedObjectContext?.deleteObject(result)
            }
        }
        self.performSegueWithIdentifier("logOutSegue", sender: self)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
