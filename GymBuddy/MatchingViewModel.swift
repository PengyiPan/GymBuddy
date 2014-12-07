//
//  MatchingViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 11/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class MatchingViewModel {
            
    init(){
    }

    func makeDatabaseQuery(receivedQueryTime:String, receivedQueryLocation:String,receivedQuerySport: String,receivedQueryCategory:String,viewCtrl:MatchingViewController){
        
        var receivedQuerySportCopy = "'" + receivedQuerySport + "'"
        
        
        //filtered records posted by this user
        var my_Netid = ""
        
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            my_Netid = user.net_id
        }
        
        let date = NSDate()
        let str_date = dateformatterDate(date)
        let str_date_copy = "'" + str_date + "'"
        let my_netid_copy =  "'" +  my_Netid  + "'"

        //var bodyData = "query= SELECT * FROM PostedWorkoutRecord2 WHERE sport_type = " + receivedQuerySportCopy + " AND time_start >= " + "'" + str_date + "'"
        
        var bodyData1 = "query= SELECT * FROM PostedWorkoutRecord2 AS pwr, PostedBy as pb WHERE pwr.sport_type = " + receivedQuerySportCopy + " AND pwr.time_start >= " + str_date_copy
        var bodyData2 =  " AND pwr.record_id = pb.record_id " + "AND NOT (pb.net_id = \(my_netid_copy))"
        
        var bodyData = bodyData1 + bodyData2
        
        
//        if (!injectionProtection(bodyDatapre)){
//            viewCtrl.popUpAlertDialog("Alert", message: "Potential Injection Detected.", buttonText: "Ok")
//        } else {
//            bodyData = bodyDatapre
//        
//        }
        
        
        
        //query = "query= SELECT * FROM User WHERE net_id = " + net_id + " AND password = " +
        //SELECT * FROM PostedWorkoutRecord2 AS pwr WHERE pwr
        
        
        
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
                self.parseJsonData(anyObj!, receivedQueryTime:receivedQueryTime, receivedQueryLocation:receivedQueryLocation, receivedQueryCategory:receivedQueryCategory, viewCtrl:viewCtrl)
                
            }
        
        
        
    
    }
    
    //return true if contains illegal phrase
    func injectionProtection(query:String) -> Bool {
        //"(?=.*[password||delete||drop])||(?=.*\")"
        if Regex("(?=.*(drop|create|delete|password))").test(query) {
            return true
        }
        return false
    }
    
    
    class Regex {
        let internalExpression: NSRegularExpression
        let pattern: String
        
        init(_ pattern: String) {
            self.pattern = pattern
            var error: NSError?
            self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
        }
        
        func test(input: String) -> Bool {
            let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
            return matches.count > 0
        }
    }
    
    func parseJsonData(anyObj:AnyObject, receivedQueryTime:String, receivedQueryLocation:String,receivedQueryCategory:String, viewCtrl:MatchingViewController){
        
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
        
        
        
        
        
        // for computing time difference
        var r: String = receivedQueryTime
        var r_year = 2000 + r.componentsSeparatedByString(", ")[0].componentsSeparatedByString("/")[2].toInt()!
        var r_month = r.componentsSeparatedByString(", ")[0].componentsSeparatedByString("/")[0].toInt()
        var r_day = r.componentsSeparatedByString(", ")[0].componentsSeparatedByString("/")[1].toInt()
        
        var r_hour = r.componentsSeparatedByString(", ")[1].componentsSeparatedByString(":")[0].toInt()
        var r_min = r.componentsSeparatedByString(", ")[1].componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0].toInt()
        
        //for computing heuristic
        let categoryData: NSArray = NSArray(objects:"Pro","Advanced","Intermediate","Beginner","Other")
        let locationData: NSArray = NSArray(objects:"East","Central","West","Other")

        //let categoryData = ["Pro","Advanced","Intermediate","Beginner","Other"]
        //let locationData = ["East","Central","West","Other"]
        
        for record in list{
            
            var s: String = record.time_start!
            
            
            var s_year = s.componentsSeparatedByString(" ")[0].componentsSeparatedByString("-")[0].toInt()
            var s_month = s.componentsSeparatedByString(" ")[0].componentsSeparatedByString("-")[1].toInt()
            var s_day = s.componentsSeparatedByString(" ")[0].componentsSeparatedByString("-")[2].toInt()
            
            var s_hour = s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0].toInt()
            var s_min = s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1].toInt()
            
//            var sTime =
//            s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0] + ":" + s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1]
//            
//            var startDate: String = s.componentsSeparatedByString(" ")[0] as String
//            var dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            var interval_in_min = (r_year - s_year!)*15379200 + (r_month! - s_month!)*43200 + (r_day! - s_day!)*1440 + (r_hour! - s_hour!)*60 + (r_min! - s_min!)

            //println(interval_in_min)
            //var interval_in_min = interval_2

            let filtered_s_cat = categoryData.indexOfObject(record.sport_sub_type!)
            let filtered_r_cat = categoryData.indexOfObject(receivedQueryCategory)
            let filtered_s_loc = locationData.indexOfObject(record.location!)
            let filtered_r_loc = locationData.indexOfObject(receivedQueryLocation)
            
//            var filtered_s_cat = categoryData.filter { $0 == record.sport_sub_type }[0].toInt()
//            //println(categoryData.filter { $0 == record.sport_sub_type })
//            var filtered_r_cat = categoryData.filter { $0 == receivedQueryCategory }[0].toInt()
//            var filtered_s_loc = locationData.filter { $0 == record.location}[0].toInt()
//            var filtered_r_loc = locationData.filter { $0 == receivedQueryLocation}[0].toInt()
            
            var cat_value = abs(filtered_r_cat - filtered_s_cat)
            var loc_value = abs(filtered_r_loc - filtered_s_loc)
            
//          if cat/location is "other", incluence on heuristics should be same but >= difference between two listed options
            
            if filtered_r_loc == 3 && filtered_s_loc == 3 {
                loc_value = 1
            } else if filtered_r_loc == 3 || filtered_s_loc == 3 {
                loc_value = 4
            }
            
            
            if filtered_r_cat == 3 && filtered_s_cat == 3 {
                cat_value = 1
            } else if filtered_r_cat == 3 || filtered_s_cat == 3 {
                cat_value = 4
            }
            
            record.h_value = abs(interval_in_min) - cat_value*30 - loc_value*45
            
            //println(record.time_start)
            //println(record.h_value)
        }
        
        
        
        list.sort({ $0.h_value < $1.h_value})
        
        //sort the list
        
        viewCtrl.didGetQueryResult(list)
        
    }
    
    
    //find difference between dates
//    let DATE_FORMATTER = NSDateFormatter();
//    let MONTH_ABBREVIATIONS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dev"];
//    let MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
//    
//    func convertUTCDateToLocalDate(utcDate: NSDate) -> NSDate {
//            let currTimeZone = NSTimeZone.systemTimeZone()
//            let diff = Double(currTimeZone.secondsFromGMT)
//            return NSDate(timeInterval: diff, sinceDate: utcDate)
//        }
//        
//    func getTimeWithDateMonthYear(date: NSDate) -> String {
//            let convertedDate = self.convertUTCDateToLocalDate(date)
//            let components = NSCalendar.currentCalendar().components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: convertedDate)
//            let timeOfDay = String(components.hour) + ":" + String(components.minute)
//            let timeOfYear = MONTHS[components.month - 1] + " " + String(components.day)
//            return timeOfYear + ", " + String(components.year) + " at " + timeOfDay
//        }
//        
//    func getTimeDifferenceSinceNow(oldDate: NSDate) -> String {
//            return getTimeDifferenceBetweenDates(NSDate(timeIntervalSinceNow: 0), oldDate: oldDate)
//        }
//        
//    func getTimeDifferenceBetweenDates(newDate: NSDate, oldDate: NSDate) -> String {
//        let timeDiff = newDate.timeIntervalSinceDate(oldDate)
//        let timeDiffInt = Int(timeDiff + 0.5)
//        
//        if timeDiffInt < 60 {
//            return String(timeDiffInt) + "s"
//        } else if timeDiffInt < 3600 {
//            return String(timeDiffInt/60) + "m"
//        } else if timeDiffInt < 86400 {
//            return String(timeDiffInt/3600) + "h"
//        } else if timeDiffInt < 604800 {
//            return String(timeDiffInt/86400) + "d"
//        } else if timeDiffInt < 2419200 {
//            return String(timeDiffInt/604800) + "w"
//        } else {
//            let convertedDate = self.convertUTCDateToLocalDate(oldDate)
//            let components = NSCalendar.currentCalendar().components(.MonthCalendarUnit | .DayCalendarUnit, fromDate: convertedDate)
//            return MONTH_ABBREVIATIONS[components.month - 1] + " " + String(components.day)
//        }
//    }

    
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    
    
    
    
    
    
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
    
    
    func dateformatterDate(date: NSDate) -> NSString
    {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "ETC")
        
        return dateFormatter.stringFromDate(date)
        
        
    }
    
    func makeAlertString(post:PostedWorkoutRecord)-> NSString{
        var s: String = post.time_start!
        
        var e: String = post.time_end!
        
        var startTime =
        s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0] + ":" + s.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1]
        
        var startDate: String = s.componentsSeparatedByString(" ")[0] as String
        
        var endTime =
        e.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[0] + ":" + e.componentsSeparatedByString(" ")[1].componentsSeparatedByString(":")[1]
        
        var endDate: String = e.componentsSeparatedByString(" ")[0] as String
        
        
        return "\n" + dateStringToWeekday(startDate) + " " + startDate + " " + startTime + " \n -\n" + dateStringToWeekday(endDate) + " " + endDate + " " + endTime + "\n" + "\nLocation: " + post.location! + "\nSport: " + post.sport_type! + "\nType: " + post.sport_sub_type!
        
        
    }

    

    
}
