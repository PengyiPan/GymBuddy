//
//  AddPostViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class AddPostViewModel {
    
    
    init(){
    }
    
    func dateToString(date:NSDate) -> NSString{
        let dateFormatter = NSDateFormatter()
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
        
        }
    
    func dateToPostString(date:NSDate) -> NSString {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)

    }
    
    //TODO need to write using xml or SQL
    func getLocationData() -> [NSString] {
        let locationData = ["East","Central","West","Other"]
        return locationData
    }
    
    //TODO need to write using xml or SQL
    func getSportData() -> [NSString] {
        let sportData = ["Swimming", "Basketball", "Tennis","Workout","Running","Soccer","Other"]
        return sportData
    }
    
    //TODO need to write using xml or SQL
    func getCategoryData() -> [NSString] {
        let categoryData = ["Pro","Advanced","Intermediate","Beginner","Other"]
        return categoryData
    }
    
    func insertToDatabase(posterNetId:String,startTime:String, endTime:String, location:String, sport:String, category:String, viewCtrl:AddPostViewController){
        
        var startTimeCopy = "'" + startTime + "'"
        var endTimeCopy = "'" + endTime + "'"
        var locationCopy = "'" + location + "'"
        var sportCopy = "'" + sport + "'"
        var categoryCopy = "'" + category + "'"
        
        var bodyData = "query= INSERT INTO PostedWorkoutRecord2 (`time_start`, `time_end`, `location`, `sport_type`, `sport_sub_type`) VALUES (" + startTimeCopy + "," + endTimeCopy + "," + locationCopy + "," + sportCopy + "," + categoryCopy + ")"

        var URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var error: NSError?
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                var anyObj1: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                
                bodyData = "query= SELECT `record_id` FROM `PostedWorkoutRecord2` WHERE `time_start` = " + startTimeCopy + " AND `time_end` = " + endTimeCopy
                
                request.HTTPMethod = "POST"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                    {
                        (response, data, error) in
                        var error: NSError?
                        var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                        var anyObj1: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                        
                        var list:Array<PostedWorkoutRecord> = []
                        if  anyObj1 is Array<AnyObject> {
                            
                            for json in anyObj1 as Array<AnyObject>{
                                var record:PostedWorkoutRecord = PostedWorkoutRecord()
                                record.record_id = (json["record_id"] as AnyObject? as? String) ?? ""
                                
                                list.append(record)
                                
                            }
                        }
                        
                        var gotRecordId = list[0].record_id!
                        
                        var postedNetIdCopy = "'" + posterNetId + "'"
                        var recordIdCopy = "'" + gotRecordId + "'"
                        var currentTimeCopy = "'" + self.dateToPostString(NSDate()) + "'"
                        
                        bodyData = "query= INSERT INTO `PostedBy`(`net_id`, `record_id`, `time_posted`) VALUES (" + postedNetIdCopy + "," + recordIdCopy + "," + currentTimeCopy + ")"
                        
                        var URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
                        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
                        request.HTTPMethod = "POST"
                        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                            {
                                (response, data, error) in
                                var error: NSError?
                                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                                var anyObj1: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                                
                           viewCtrl.didReceivdPostResult()
                        }
                        
                }
                
            }
        
    }
    
    
    
    
    
}


