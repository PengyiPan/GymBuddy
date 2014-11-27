//
//  MatchingViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 11/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class MatchingViewModel {
            
    init(){
    }

    func makeDatabaseQuery(receivedQueryTime:String, receivedQueryLocation:String,receivedQuerySport: String,receivedQueryCategory:String,viewCtrl:MatchingViewController){
        
        var bodyData = "query= SELECT * FROM PostedWorkoutRecord2"
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var error: NSError?
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                
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
    
    func makeCellTitleString(post:PostedWorkoutRecord)-> NSString{
        var s: String = post.time_start!

        var e: String = post.time_end!
        
        var startTime =
        s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0] + ":" + s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1]
        
        var startDate: String = s.componentsSeparatedByString(" ")[0] as String
        
        var endTime =
        e.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0] + ":" + e.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1]
        
        var endDate: String = e.componentsSeparatedByString(" ")[0] as String

        if (startDate == endDate){
            
            return dateStringToWeekday(startDate) + " " + startDate + " " + startTime + " - " + endTime
            
        }else{
            return dateStringToWeekday(startDate) + " " + startDate + " " + startTime + " - " + dateStringToWeekday(endDate) + " " + endDate + " " + endTime
        }

        
    }
    
    func makeCellDetailString(post:PostedWorkoutRecord) ->NSString{
        return "Location: " + post.location! + "   Sport: " + post.sport_type! + "   Type: " + post.sport_sub_type!
    }
    
    func dateStringToWeekday(dateString:String) ->NSString{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let myDate = dateFormatter.dateFromString(dateString)!
        
        let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: myDate).weekday
        
        let weekDayStr = NSCalendar.currentCalendar().weekdaySymbols[myWeekday-1] as NSString
        
        let abbrStr = weekDayStr.substringWithRange(NSRange(location: 0, length: 3))
        
        return abbrStr

    }
    

    
}
