//
//  RegistrationModel.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/28/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation

class RegistrationModel {
    
    enum RegisterResult {
        case AlreadyExists
        case RegisterSuccess
        case NonValidPassword
    }
    
    func postCredentials(viewCtrl: RegistrationViewController, netID:String, password:String){
        var user = User()
        user.net_id = netID
        user.password = password
        
        if validatePassword(password) == false {
            viewCtrl.didGetPostResult(RegisterResult.NonValidPassword, user:user)
            return
        }
        
        if injectionProtection(password) == true {
            viewCtrl.didGetPostResult(RegisterResult.NonValidPassword, user:user)
            return
        }
        
        var net_id = "'" + netID + "'"
        var query = "query= SELECT * FROM User WHERE net_id = " + net_id
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Check Duplicated NetID Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                var err: NSError?
                let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),error: &err)
                if err != nil { //if there is an error parsing Json, print it
                    println(err?.localizedDescription)
                }
                var list:Array<User> = []
                if  jsonResult is Array<AnyObject> {
                    for json in jsonResult as Array<AnyObject>{
                        var user:User = User()
                        user.net_id = (json["net_id"] as AnyObject? as? String) ?? ""
                        user.password = (json["password"] as AnyObject? as? String) ?? ""
                        user.last_name = (json["last_name"] as AnyObject? as? String) ?? ""
                        user.first_name = (json["first_name"] as AnyObject? as? String) ?? ""
                        user.gender = (json["gender"] as AnyObject? as? String) ?? ""
                        user.picture_url = (json["picture_url"] as AnyObject? as? String) ?? ""
                        user.numb_thumb_ups = (json["num_thumb"] as AnyObject? as? String) ?? ""
                        user.signature = (json["signature"] as AnyObject? as? String) ?? ""
                        list.append(user)
                    }
                }
                if list.isEmpty {
                    self.sendUserCredentials(viewCtrl, user: user)
                } else {
                    viewCtrl.didGetPostResult(RegisterResult.AlreadyExists, user: user)
                }
        }
    }
    
    func sendUserCredentials(viewCtrl:RegistrationViewController, user:User) {
        var net_id = "'" + user.net_id! + "'"
        var passwordCopy = "'" + user.password! + "'"
        var query = "query= INSERT INTO User (`net_id`, `password`, `last_name`, `first_name`, `gender`, `picture_url`, `num_thumbs`, `signature`) VALUES (" + net_id + ", " + passwordCopy + ", NULL, NULL, NULL, 'default picture', 0, NULL)"
        user.picture_url = "default picture"
        user.numb_thumb_ups = "0"
        //println(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Add User Account Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(RegisterResult.RegisterSuccess, user:user)
        }
    }
    
    func validatePassword(password:String) -> Bool {
        if countElements(password) < 5 || countElements(password) > 10 {
            return false
        } else if !Regex("(?=.*\\d)(?=.*[a-z])").test(password) {
            return false
        }
        return true
    }
    
    func injectionProtection(query:String) -> Bool {
        //"(?=.*[password||delete||drop])||(?=.*\")"
        if Regex("(?=.*(drop|create|delete|password|\"))").test(query) {
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
