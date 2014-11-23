//
//  MatchingViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 11/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class MatchingViewModel {
    
    var list:Array<Business> = []
    
    // left only 2 fields for demo
    struct Business {
        var id : Int = 0
        var name = ""
    }
    
    
    init(){
    }

    func makeDatabaseQuery(receivedQueryTime:String, receivedQueryLocation:String,receivedQuerySport: String,receivedQueryCategory:String,viewCtrl:MatchingViewController){
        
        var bodyData = "query= SELECT * FROM PostedWorkOutRecord"
        
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var error: NSError?
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                    error: &error)
                
                //parse received Json data
                self.parseJsonData(anyObj!,viewCtrl:viewCtrl)
                
            }
        
    
    }
    
    func parseJsonData(anyObj:AnyObject, viewCtrl:MatchingViewController){
        
        var list:Array<PostedWorkoutRecord> = []
        
        if  anyObj is Array<AnyObject> {
   
            for json in anyObj as Array<AnyObject>{
                var record:PostedWorkoutRecord = PostedWorkoutRecord()
                record.record_id = (json["record_id"] as AnyObject? as? String) ?? ""
                record.time_start  =  (json["time_start"]  as AnyObject? as? String) ?? ""
                record.time_end = (json["time_end"] as AnyObject? as? String) ?? ""
                record.location = (json["location"] as AnyObject? as? String) ?? ""
                record.sport_type = (json["sport_type"] as AnyObject? as? String) ?? ""
                record.sport_sub_type = (json["sport_sub_type"] as AnyObject? as? String) ?? ""
                
                list.append(record)
                
                
            }
            
        } 
        
        viewCtrl.didGetQueryResult(list)
        
    }
}
