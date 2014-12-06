//
//  ProfileTableViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/28/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableViewController:UITableViewController {
    
    @IBOutlet weak var firstNameContent: UILabel!

    @IBOutlet weak var lastNameContent: UILabel!

    @IBOutlet weak var genderContent: UILabel!

    @IBOutlet weak var signatureContent: UILabel!

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
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            photoContent.text = user.picture_url;
            firstNameContent.text = user.first_name;
            lastNameContent.text = user.last_name;
            genderContent.text = user.gender;
            thumbsContent.text = user.num_thumbs;
            signatureContent.text = user.signature;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
