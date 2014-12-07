//
//  ProfileUpdateModel.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/4/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation

class ProfileUpdateModel {
    
    class func updateUserProfile(viewCtrl:ProfileEditViewController, netID:String, attributeContent:String, attributeType:EditAttribute) {
        var net_id = "'" + netID + "'"
        var content_pre = "'" + attributeContent + "'"
        
        var content = ""
        
        if (Regex("(?=.*(drop|create|delete|password|\"))").test(content_pre)){
            viewCtrl.popUpAlertDialog("Alert", message: "Potential Injection Detected.", buttonText: "Ok")
        } else {
            content = content_pre
        }
        
        
        
        var attributeTitle = ""
        switch attributeType {
        case EditAttribute.EditFirstName:
            attributeTitle = "first_name"
        case EditAttribute.EditLastName:
            attributeTitle = "last_name"
        case EditAttribute.EditSignature:
            attributeTitle = "signature"
        default:
            break
        }
        
        var query = "query= UPDATE User SET \(attributeTitle) = \(content) WHERE net_id = \(net_id)"
        //NSLog(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Update User Profile Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(UpdateResult.Success, attributeContent: attributeContent, attributeType: attributeType)
        }
        
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

    
    
    class func updateChoiceProfile(viewCtrl:ProfileChoiceOverallViewController, netID:String, attributeContent:String, attributeType:EditAttribute) {
        var net_id = "'" + netID + "'"
        var content = "'" + attributeContent + "'"
        var attributeTitle = ""
        switch attributeType {
        case EditAttribute.EditGender:
            attributeTitle = "gender"
        case EditAttribute.EditPicture:
            attributeTitle = "picture_url"
        default:
            break
        }
        
        var query = "query= UPDATE User SET \(attributeTitle) = \(content) WHERE net_id = \(net_id)"
        //NSLog(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Update User Profile Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(UpdateResult.Success, attributeContent: attributeContent, attributeType: attributeType)
        }
    }
    
    class func updatePassword(viewCtrl:EditPasswordViewController, netID:String, password:String){
        var net_id = "'" + netID + "'"
        var passwordCopy = "'" + password + "'"
        var query = "query= UPDATE User SET password = \(passwordCopy) WHERE net_id = \(net_id)"
        //NSLog(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                //NSLog("Update User Profile Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(UpdateResult.Success, password:password)
        }
    }
    
    func updateUserData(viewCtrl:ProfileViewController, netID:String){
        var net_id = "'" + netID + "'"
        var query = "query= SELECT * FROM User WHERE net_id = \(net_id)"
        NSLog(query)
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
                self.parseJsonData(jsonResult, viewCtrl: viewCtrl)
        }
    }
    
    func parseJsonData(anyObj:AnyObject?, viewCtrl:ProfileViewController){
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
        viewCtrl.didGetQueryResult(UpdateResult.Success, user: list[0])
    }
}