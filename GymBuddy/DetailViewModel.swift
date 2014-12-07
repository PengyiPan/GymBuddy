//
//  DetailViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class DetailViewModel {
    
    
    init(){
    }

    func makeDatabaseQuery(receivedRecordId:String,viewCtrl:DetailViewController){
        
        var bodyData = "query= SELECT * FROM PostedBy WHERE record_id = " + receivedRecordId

        
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
                //parse received Json data
                self.parsePostedByJsonData(anyObj1!,viewCtrl:viewCtrl)
        }
        
        
    }
    
    
    
    func parsePostedByJsonData(anyObj:AnyObject, viewCtrl:DetailViewController){
        
        var list:Array<PostedBy> = []
        
        
        if  anyObj is Array<AnyObject> {
            
            for json in anyObj as Array<AnyObject>{
                
                var record:PostedBy = PostedBy()
                
                record.net_id = (json["net_id"] as AnyObject? as? String) ?? ""
                record.record_id  =  (json["record_id"]  as AnyObject? as? String) ?? ""
                record.time_posted = (json["time_posted"] as AnyObject? as? String) ?? ""
                
                
                list.append(record)
                
                
            }
            var netId = list[0].net_id!
            
            self.makeUserDatabaseQuery(netId, viewCtrl: viewCtrl)
            
        }
    }
    
    func makeUserDatabaseQuery(receivedNetId:String,viewCtrl:DetailViewController){
        
        var bodyData = "query= SELECT * FROM User WHERE net_id = " + "'" + receivedNetId + "'"
        
        var URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var error: NSError?
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                var anyObj2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                //parse received Json data
 
                self.parseJsonData(anyObj2!,viewCtrl:viewCtrl)
                
        }
        
        
    }
    
    func parseJsonData(anyObj:AnyObject, viewCtrl:DetailViewController){
        
        var list:Array<User> = []
        
        
        if  anyObj is Array<AnyObject> {
            
            for json in anyObj as Array<AnyObject>{
                
                var record:User = User()
                
                record.net_id = (json["net_id"] as AnyObject? as? String) ?? ""
                record.password  =  (json["password"]  as AnyObject? as? String) ?? ""
                record.last_name = (json["last_name"] as AnyObject? as? String) ?? ""
                record.first_name = (json["first_name"] as AnyObject? as? String) ?? ""
                record.gender = (json["gender"] as AnyObject? as? String) ?? ""
                record.picture_url = (json["picture_url"] as AnyObject? as? String) ?? ""
                record.numb_thumb_ups = (json["num_thumbs"] as AnyObject? as? String) ?? ""
                record.signature = (json["signature"] as AnyObject? as? String) ?? ""
                
                
                list.append(record)
                
                
            }
            
            viewCtrl.didReceiveQueryResult(list)
            
        }
    }
    
    func thumbUp(net_id:String, viewCtrl:DetailViewController){
        
        var bodyData = "query= SELECT * FROM User WHERE net_id = " + "'" + net_id + "'"
        
        var URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var error: NSError?
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                var anyObj2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                var list:Array<User> = []
                
                
                if  anyObj2 is Array<AnyObject> {
                    
                    for json in anyObj2 as Array<AnyObject>{
                        
                        var record:User = User()

                        record.numb_thumb_ups = (json["num_thumbs"] as AnyObject? as? String) ?? ""
                        
                        list.append(record)
                        
                    }
                    
                }
                
                var thumbNum:Int = list[0].numb_thumb_ups!.toInt()!
                thumbNum += 1
                var newThumbNum = String(thumbNum)
                
                var netId: String = "'" + net_id + "'"
                var bodyData = "query= UPDATE User SET num_thumbs = " + newThumbNum + " WHERE net_id = " + netId
                var URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
                var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
                request.HTTPMethod = "POST"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                    {
                        (response, data, error) in
                        var error: NSError?
                        var output = NSString(data: data, encoding: NSUTF8StringEncoding) // output as string for debugging
                        var anyObj2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &error)
                        //parse received Json data
                        
                        self.makeUserDatabaseQuery(net_id, viewCtrl: viewCtrl)
                }
                
        }
        
    }

}
