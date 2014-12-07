//
//  DetailViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let myModel = DetailViewModel()
    
    var receivedQueryTime = ""
    var receivedQueryLocation = ""
    var receivedQuerySport = ""
    var receivedQueryCategory = ""
    
    @IBOutlet weak var thumbUpBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var numThumbs: UILabel!

    var receivedRecord: PostedWorkoutRecord = PostedWorkoutRecord()
    
    var userToPresent: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        thumbUpBtn.alpha = 0
        myModel.makeDatabaseQuery(receivedRecord.record_id!, viewCtrl: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set to only support portrait, too lazy to do the landscape shit
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toMatchingSegue") {
            var destinationVC = segue.destinationViewController as MatchingViewController;
            destinationVC.receivedQueryTime = self.receivedQueryTime
            destinationVC.receivedQueryLocation = self.receivedQueryLocation
            destinationVC.receivedQuerySport = self.receivedQuerySport
            destinationVC.receivedQueryCategory = self.receivedQueryCategory
        } else if (segue.identifier == "embedProfileSegue"){
            //NSLog("embed detail table view segue called")
        }
    }
    
    @IBAction func thumbUp(sender: UIButton) {
        myModel.thumbUp(userToPresent.net_id!, viewCtrl: self)
    }
    
    func didReceiveQueryResult(data: Array<User>){
        //NSLog("Detail View Controller receives query results")
        userToPresent = data[0]
        thumbUpBtn.alpha = 1
        numThumbs.text = userToPresent.numb_thumb_ups
        profilePic.image = UIImage(named: userToPresent.picture_url!)
        var tableController = self.childViewControllers.first as DetailTableViewController
        tableController.firstName = userToPresent.first_name!
        tableController.LastName = userToPresent.last_name!
        tableController.gender = userToPresent.gender!
        tableController.signature = userToPresent.signature!
        var data: Array<String> = []
        data.append("First Name")
        data.append("Last Name")
        data.append("Gender")
        data.append("Signature")
        tableController.refreshCells(data)
    }

}