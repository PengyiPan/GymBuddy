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
    
    @IBOutlet weak var thumbNumField: UILabel!
    @IBOutlet weak var picImage: UIImageView!
    let myModel = ProfileUpdateModel()
    let tapRec = UITapGestureRecognizer()
    @IBAction func logOutButton(sender: AnyObject) {
        //NSLog("User Credentials in CoreData Deleted")
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            for result in fetchResults {
                managedObjectContext?.deleteObject(result)
            }
        }
        self.performSegueWithIdentifier("logOutSegue", sender: self)
    }
    @IBAction func viewPostedButton(sender: AnyObject) {
        
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
        tapRec.addTarget(self, action: "tappedImage")
        picImage.addGestureRecognizer(tapRec)
        picImage.userInteractionEnabled = true
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            thumbNumField.text = user.num_thumbs
            picImage.image = UIImage(named: user.picture_url)
            myModel.updateUserData(self, netID:user.net_id)
        }
    }
    
    func tappedImage() {
        self.performSegueWithIdentifier("EditPicSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //NSLog("Ready to launch segue with name " + segue.identifier!)
        if segue.identifier == "EditPicSegue" {
            var viewController = segue.destinationViewController as ProfileChoiceOverallViewController
            viewController.myEditThing = EditAttribute.EditPicture
        }
    }
    
    func didGetQueryResult(result:UpdateResult, user:User) {
        if result == UpdateResult.Success {
            let fetchRequest = NSFetchRequest(entityName: "UserData")
            if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
                var local:UserData = fetchResults[0];
                local.num_thumbs = user.numb_thumb_ups!
                thumbNumField.text = local.num_thumbs
            }
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
}
