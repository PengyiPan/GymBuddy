//
//  MyPostedRecordsViewController.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/7/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MyPostedRecordsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var myData: Array<PostedWorkoutRecord> = []
    
    let myModel = MyPostedRecordsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var netID:String = ""
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            netID = user.net_id
        }
        myModel.queryMyWorkoutRecords(self, netID: netID)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("recordCell") as UITableViewCell
        cell.textLabel?.text =  myModel.makeCellTitleString(myData[indexPath.row] as PostedWorkoutRecord)
        cell.detailTextLabel?.text = myModel.makeCellDetailString(myData[indexPath.row] as PostedWorkoutRecord)
        //NSLog("changed cell with text " + cell.textLabel!.text!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do nothing
    }
    
    func didGetQueryResult(resultList:Array<PostedWorkoutRecord>){
        //NSLog("MyPostedRecordsViewController got query results")
        myData = resultList
        myTableView.reloadData()
    }
    
    //the animation effect
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
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
    
}
