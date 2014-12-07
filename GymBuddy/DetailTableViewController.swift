//
//  DetailTableViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewController:UITableViewController {
    
    var myData: Array<String> = []
    var firstName:String = ""
    var LastName:String = ""
    var gender:String = ""
    var signature:String = ""
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("attributeCell") as UITableViewCell
        let row = indexPath.row
        var attribute = myData[row]
        cell.textLabel?.text = attribute
        //NSLog("Detail table view's textLable created " + attribute)
        switch attribute {
        case "First Name":
            cell.detailTextLabel?.text = firstName
        case "Last Name":
            cell.detailTextLabel?.text = LastName
        case "Gender":
            cell.detailTextLabel?.text = gender
        case "Contact Info":
            cell.detailTextLabel?.text = signature
            cell.detailTextLabel?.numberOfLines = 5
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set to only support portrait, too lazy to do the landscape
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    func refreshCells(data: Array<String>) {
        myData = data
        self.tableView.reloadData()
    }
}
