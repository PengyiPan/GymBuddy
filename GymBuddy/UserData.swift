//
//  UserData.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 11/28/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation
import CoreData

class UserData: NSManagedObject {

    @NSManaged var net_id: String
    @NSManaged var password: String
    @NSManaged var first_name: String
    @NSManaged var last_name: String
    @NSManaged var gender: String
    @NSManaged var picture_url: String
    @NSManaged var num_thumbs: String
    @NSManaged var signature: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, netID: String, password: String, firstName:String?, lastName:String?, gender:String?, pictureURL:String?, numThumbs:String?, signature:String?) -> UserData {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: moc) as UserData
        newItem.net_id = netID
        newItem.password = password
        
        if firstName != nil {
            newItem.first_name = firstName!
        } else {
            newItem.first_name = "Empty"
        }
        
        if lastName != nil {
            newItem.last_name = lastName!
        } else {
            newItem.last_name = "Empty"
        }
        
        if gender != nil {
            newItem.gender = gender!
        } else {
            newItem.gender = "Empty"
        }
        
        if pictureURL != nil {
            newItem.picture_url = pictureURL!
        } else {
            newItem.picture_url = "Empty"
        }
        
        if numThumbs != nil {
            newItem.num_thumbs = numThumbs!
        } else {
            newItem.num_thumbs = "Empty"
        }
        
        if signature != nil {
            newItem.signature = signature!
        } else {
            newItem.signature = "Empty"
        }
        return newItem
    }
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, netID:String, password:String) -> UserData {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: moc) as UserData
        newItem.net_id = netID
        newItem.password = password
        newItem.first_name = "Empty"
        newItem.last_name = "Empty"
        newItem.gender = "Empty"
        newItem.picture_url = "Empty"
        newItem.num_thumbs = "0"
        newItem.signature = "Empty"
        return newItem
    }

}
