//
//  ProfileChoiceViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/5/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfileChoiceViewController:UITableViewController {
    var myEditThing:EditAttribute = EditAttribute.EditGender
    var selectedAttribute:String = ""
    var selected = Dictionary<String, NSIndexPath>()
    let genderItems = ["Male", "Female", "Complicated"]
    let pictureItems = ["default picture", "doge", "bluedevil"]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch myEditThing {
        case EditAttribute.EditGender:
            return genderItems.count
        case EditAttribute.EditPicture:
            return pictureItems.count
        default:
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            switch myEditThing {
            case EditAttribute.EditGender:
                selectedAttribute = user.gender
                NSLog("Before change, user's gender is " + selectedAttribute)
            case EditAttribute.EditPicture:
                selectedAttribute = user.picture_url
                NSLog("Before change, user's picture is " + selectedAttribute)
            default:
                selectedAttribute = ""
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileChoiceCell") as UITableViewCell
        let row = indexPath.row
        var choice = ""
        switch myEditThing {
        case EditAttribute.EditGender:
            choice = genderItems[row]
        case EditAttribute.EditPicture:
            choice = pictureItems[row]
        default:
            choice = ""
        }

        cell.textLabel?.text = choice
        switch myEditThing {
        case EditAttribute.EditGender:
            if choice == selectedAttribute {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                selected.updateValue(indexPath, forKey: choice)
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        case EditAttribute.EditPicture:
            if choice == selectedAttribute {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                selected.updateValue(indexPath, forKey: choice)
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            var image = UIImage(named: pictureItems[row])
            cell.imageView?.image = image
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        if selectedAttribute.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
            var prevSelected = tableView.cellForRowAtIndexPath(selected[selectedAttribute]!) as UITableViewCell!
            prevSelected.accessoryType = UITableViewCellAccessoryType.None
        }
        selectedAttribute = selectedCell.textLabel!.text!
        selected.removeAll(keepCapacity: false)
        selected.updateValue(indexPath, forKey: selectedAttribute)
        selectedCell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
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