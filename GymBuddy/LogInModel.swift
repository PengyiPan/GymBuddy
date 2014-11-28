//
//  LogInModel.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/27/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation

class LogInModel {
    
    func searchForCredentials(viewCtrl: LogInViewController, netID:String, password:String){
        var net_id = "'" + netID + "'"
        var passwordCopy = "'" + password + "'"
        var query = "query= SELECT * FROM User WHERE net_id = " + net_id + " AND password = " + passwordCopy
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                println("Search Credentials Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                var err: NSError?
                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &err)
                if err != nil { //if there is an error parsing Json, print it
                    println(err?.localizedDescription)
                }
                //parse received Json data
                self.parseJsonData(jsonResult,viewCtrl:viewCtrl)
        }
    }
    
    func parseJsonData(anyObj:AnyObject?, viewCtrl:LogInViewController){
        var list:Array<User> = []
        if  anyObj is Array<AnyObject> {
            for json in anyObj as Array<AnyObject>{
                var user:User = User()
                user.net_id = (json["net_id"] as AnyObject? as? String) ?? ""
                user.password = (json["password"] as AnyObject? as? String) ?? ""
                user.last_name = (json["last_name"] as AnyObject? as? String) ?? ""
                user.first_name = (json["first_name"] as AnyObject? as? String) ?? ""
                user.gender = (json["gender"] as AnyObject? as? String) ?? ""
                user.picture_url = (json["picture_url"] as AnyObject? as? String) ?? ""
                user.numb_thumb_ups = (json["num_thumb_ups"] as AnyObject? as? String) ?? ""
                user.signature = (json["signature"] as AnyObject? as? String) ?? ""
                list.append(user)
            }
        }
        viewCtrl.didGetQueryResult(list)
    }
}