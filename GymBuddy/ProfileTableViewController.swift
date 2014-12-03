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
            
//            if countElements(user.picture_url.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
//                photoContent.text = "Empty >";
//            } else {
//                photoContent.text = user.picture_url + " >";
//            }
            
            if countElements(user.first_name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
                firstNameContent.text = "Empty >";
            } else {
                firstNameContent.text = user.first_name + " >";
            }
            
            if countElements(user.last_name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
                lastNameContent.text = "Empty >";
            } else {
                lastNameContent.text = user.last_name + " >";
            }
            
            if countElements(user.gender.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
                genderContent.text = "Empty >";
            } else {
                genderContent.text = user.gender + " >";
            }
            
//            thumbsContent.text = user.num_thumbs;
            
            if countElements(user.signature.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
                signatureContent.text = "Empty >";
            } else {
                signatureContent.text = user.signature + " >";
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
}
