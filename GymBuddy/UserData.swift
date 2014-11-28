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
        }
        if lastName != nil {
            newItem.last_name = lastName!
        }
        if gender != nil {
            newItem.gender = gender!
        }
        if pictureURL != nil {
            newItem.picture_url = pictureURL!
        }
        if numThumbs != nil {
            newItem.num_thumbs = numThumbs!
        }
        if signature != nil {
            newItem.signature = signature!
        }
        return newItem
    }

}
