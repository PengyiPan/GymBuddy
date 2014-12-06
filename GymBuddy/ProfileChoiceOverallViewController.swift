//
//  ProfileChoiceOverallViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfileChoiceOverallViewController:UIViewController {
    var myEditThing:EditAttribute = EditAttribute.EditGender
    let progressView = UIProgressView(progressViewStyle: .Bar)
    
    @IBOutlet weak var navigationLabel: UINavigationItem!
    
    @IBAction func saveButton(sender: AnyObject) {
        var childController = self.childViewControllers.first as ProfileChoiceViewController
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            ProfileUpdateModel.updateChoiceProfile(self, netID: user.net_id, attributeContent: childController.selectedAttribute, attributeType: myEditThing)
        }
        
        progressView.center = view.center
        progressView.setProgress(0.5, animated: true)
        progressView.trackTintColor = UIColor.lightGrayColor()
        progressView.tintColor = UIColor.blueColor()
        view.addSubview(progressView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNavigationTitle()
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    func didGetPostResult(result:UpdateResult, attributeContent:String, attributeType:EditAttribute){
        var childController = self.childViewControllers.first as ProfileChoiceViewController
        switch  result {
        case UpdateResult.Success:
            let fetchRequest = NSFetchRequest(entityName: "UserData")
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
                var user:UserData = fetchResults[0]
                switch myEditThing {
                case EditAttribute.EditGender:
                    user.gender = attributeContent
                case EditAttribute.EditPicture:
                    user.picture_url = attributeContent
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
    
    func displayNavigationTitle() {
        switch myEditThing {
        case EditAttribute.EditGender:
            navigationLabel.title = "Gender"
        case EditAttribute.EditPicture:
            navigationLabel.title = "Picture"
        default:
            navigationLabel.title = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedChoiceTableSegue" {
            var viewController = segue.destinationViewController as ProfileChoiceViewController
            switch myEditThing {
            case EditAttribute.EditGender:
                viewController.myEditThing = EditAttribute.EditGender
            case EditAttribute.EditPicture:
                viewController.myEditThing = EditAttribute.EditPicture
            default:
                break
            }
        }
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
