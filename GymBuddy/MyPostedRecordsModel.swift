//
//  MyPostedRecordsModel.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/7/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation

class MyPostedRecordsModel {
    
    func queryMyWorkoutRecords(viewCtrl:MyPostedRecordsViewController, netID:String) {
        var net_id = "'" + netID + "'"
        
        var query = "query= SELECT * FROM PostedBy AS pb, PostedWorkoutRecord2 AS record WHERE pb.net_id = \(net_id) AND pb.record_id = record.record_id"
        //NSLog(query)
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                if error != nil{
                    println(error?.localizedDescription)
                }
                var err: NSError?
                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &err)
                if err != nil { //if there is an error parsing Json, print it
                    println(err?.localizedDescription)
                }
                self.parseJsonIDsData(jsonResult, viewCtrl: viewCtrl)
        }
    }
    
    func parseJsonIDsData(anyObj:AnyObject?, viewCtrl:MyPostedRecordsViewController) {
        var list:Array<PostedWorkoutRecord> = []
        if anyObj is Array<AnyObject> {
            //NSLog("fetched my workout records")
            for json in anyObj as Array<AnyObject> {
                var record:PostedWorkoutRecord = PostedWorkoutRecord()
                record.record_id = (json["record_id"] as AnyObject? as? String) ?? ""
                record.time_start  =  (json["time_start"]  as AnyObject? as? String) ?? ""
                record.time_end = (json["time_end"] as AnyObject? as? String) ?? ""
                record.location = (json["location"] as AnyObject? as? String) ?? ""
                record.sport_type = (json["sport_type"] as AnyObject? as? String) ?? ""
                record.sport_sub_type = (json["sport_sub_type"] as AnyObject? as? String) ?? ""
                //NSLog("added my workout record with id " + record.record_id!)
                list.append(record)
            }
        }
        viewCtrl.didGetQueryResult(list)
    }
    
    //function to delete this workout record
    func queryDeleteMyRecord(viewCtrl:MyPostedRecordsViewController, post:PostedWorkoutRecord){
        
        var this = post
        
        var t_start: String = this.time_start!
        var t_end: String = this.time_end!
        var l: String = this.location!
        var s_type: String = this.sport_type!
        
        var r_id: String = this.record_id!
        
        var time_start = "'" + t_start + "'"
        var time_end = "'" + t_end + "'"
        
        var record_id = "'" + r_id + "'"
        
        //var query = "query = SELECT * FROM PostedBy AS pb, PostedWorkoutRecord2 AS record WHERE pb.net_id = \(net_id) AND pb.record_id = record.record_id"
        println("tobedeleted record id is :" + record_id)
        
        var delete_Record = "query= DELETE FROM `PostedWorkoutRecord2` WHERE record_id = \(record_id)"
        
        
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request_1:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request_1.HTTPMethod = "POST"
        request_1.HTTPBody = delete_Record.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request_1, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                if error != nil{
                    println(error?.localizedDescription)
                }
                // donothing
                //self.parseJsonIDsData(jsonResult, viewCtrl: viewCtrl)
                //viewCtrl.viewDidLoad()
        }
        
//        NSURLConnection.sendAsynchronousRequest(request_record, queue: NSOperationQueue.mainQueue())
//            {//do nothing
//                (response, data, error) in
//                if error != nil{
//                    println(error?.localizedDescription)
//                }
//                var err: NSError?
//                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &err)
//                if err != nil { //if there is an error parsing Json, print it
//                    println(err?.localizedDescription)
//                }
//                //self.parseJsonIDsData(jsonResult, viewCtrl: viewCtrl)
//
//        }
        
        var delete_PostedBy =  "query= DELETE FROM `PostedBy` WHERE record_id = \(record_id)";

        //then delete postedby
        let URL2: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request_2:NSMutableURLRequest = NSMutableURLRequest(URL:URL2)
        request_2.HTTPMethod = "POST"
        request_2.HTTPBody = delete_PostedBy.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request_2, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                if error != nil{
                    println(error?.localizedDescription)
                }
                // donothing
                //self.parseJsonIDsData(jsonResult, viewCtrl: viewCtrl)
                viewCtrl.viewDidLoad()
        }

        
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
