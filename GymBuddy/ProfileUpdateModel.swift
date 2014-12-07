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
        var content = "'" + attributeContent + "'"
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
        println(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                NSLog("Update User Profile Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(UpdateResult.Success, attributeContent: attributeContent, attributeType: attributeType)
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
        NSLog(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                NSLog("Update User Profile Task Completed")
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
        NSLog(query)
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                NSLog("Update User Profile Task Completed")
                if error != nil{
                    println(error?.localizedDescription)
                }
                viewCtrl.didGetPostResult(UpdateResult.Success, password:password)
        }
    }
}