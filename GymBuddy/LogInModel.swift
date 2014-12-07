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
        var net_id_pre = "'" + netID + "'"
        var net_id = ""
        
        //sql injection protection

        if (injectionProtection(net_id_pre)){
            viewCtrl.popUpAlertDialog("Alert", message: "Potential Injection Detected.", buttonText: "Ok")
        } else {
            net_id = net_id_pre
        }
        
        var passwordCopy_pre = "'" + password + "'"
        var passwordCopy = ""
        
        if (injectionProtection(passwordCopy_pre)){
            viewCtrl.popUpAlertDialog("Alert", message: "Potential Injection Detected.", buttonText: "Ok")
        } else {
            passwordCopy = passwordCopy_pre
        }
        
        
        
        var query = "query= SELECT * FROM User WHERE net_id = " + net_id + " AND password = " + passwordCopy
        
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Search Credentials Task Completed")
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
                user.numb_thumb_ups = (json["num_thumbs"] as AnyObject? as? String) ?? ""
                //NSLog("user has a thumb of " + user.numb_thumb_ups!)
                user.signature = (json["signature"] as AnyObject? as? String) ?? ""
                list.append(user)
            }
        }
        viewCtrl.didGetQueryResult(list)
    }
    
    //if gorget password, ask for netid, first/lastname, and email password to netid@duke.edu
    func retrievePassword(viewCtrl: LogInViewController, netID:String, lastname:String, firstname: String){
        var net_id = "'" + netID + "'"
        var firstnamecopy = "'" + firstname + "'"
        var lastnamecopy = "'" + lastname + "'"
        
        var query = "query= SELECT * FROM User WHERE net_id = " + net_id + " AND first_name = " + firstnamecopy + " AND last_name = " + lastnamecopy

        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Search Credentials Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                var err: NSError?
                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &err)
                if err != nil { //if there is an error parsing Json, print it
                    println(err?.localizedDescription)
                }
                //parse received Json data
                self.parseJsonDataforRetrievePassword(jsonResult,viewCtrl:viewCtrl)
        }
    }
    
    func parseJsonDataforRetrievePassword(anyObj:AnyObject?, viewCtrl:LogInViewController){
        var list:Array<User> = []
        if  anyObj is Array<AnyObject> {
            for json in anyObj as Array<AnyObject>{
                var user:User = User()
                user.net_id = (json["net_id"] as AnyObject? as? String) ?? ""
                user.password = (json["password"] as AnyObject? as? String) ?? ""
                user.last_name = (json["last_name"] as AnyObject? as? String) ?? ""
                user.first_name = (json["first_name"] as AnyObject? as? String) ?? ""
                list.append(user)
            }
        }
        viewCtrl.didGetForgottenPassword(list)
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

    
    
}