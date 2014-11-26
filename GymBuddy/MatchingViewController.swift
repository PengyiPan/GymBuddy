//
//  MatchingViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class MatchingViewController: UIViewController {
    
    
    let myModel = MatchingViewModel()
    
    var receivedQueryTime = ""
    var receivedQueryLocation = ""
    var receivedQuerySport = ""
    var receivedQueryCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeQuery()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeQuery() {
        myModel.makeDatabaseQuery(receivedQueryTime, receivedQueryLocation: receivedQueryLocation, receivedQuerySport: receivedQuerySport, receivedQueryCategory: receivedQueryCategory,viewCtrl:self)
     
    }
    
    func didGetQueryResult(resultList:Array<PostedWorkoutRecord>) {

        //print all for debug
        for record in resultList {
            println(record.record_id!)
            println(record.time_start!)
            println(record.time_end!)
            println(record.location!)
            println(record.sport_type!)
            println(record.sport_sub_type!)
        }
        
        //TODO: put all data into a scrolling list
        
    
    }
    
    
  
    
}

