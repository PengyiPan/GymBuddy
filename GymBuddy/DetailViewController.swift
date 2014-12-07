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
    

    
    var receivedRecord: PostedWorkoutRecord = PostedWorkoutRecord()
    
    var userToPresent: User = User()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("received record id: " + receivedRecord.record_id!)
        
        myModel.makeDatabaseQuery(receivedRecord.record_id!, viewCtrl: self)
 
        // Do any additional setup after loading the view, typically from a nib.


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
            
            
        }
    }
    
    func didReceiveQueryResult(data: Array<User>){
        userToPresent = data[0]
        
        self.displayLabel.text = "Name: " + userToPresent.first_name! + " " + userToPresent.last_name! + 
            "Gender: " + userToPresent.gender!
      
//        self.urlLabel.text = "Url: " + userToPresent.picture_url!
//        self.ThumbLabel.text = "# of thumb ups: " + userToPresent.numb_thumb_ups!
//        self.SignatureLabel.text = "Comment: " + userToPresent.signature!
        
        
    }

}