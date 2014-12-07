//
//  AddPostViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class AddPostViewModel {
    
    
    init(){
    }
    

    
    func dateToString(date:NSDate) -> NSString{
        let dateFormatter = NSDateFormatter()
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.stringFromDate(date)
        
        }
    
    func dateToPostString(date:NSDate) -> NSString {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        return dateFormatter.stringFromDate(date)

    }
    
    //TODO need to write using xml or SQL
    func getLocationData() -> [NSString] {
        let locationData = ["East","Central","West","Other"]
        return locationData
    }
    
    //TODO need to write using xml or SQL
    func getSportData() -> [NSString] {
        let sportData = ["Swimming", "Basketball", "Tennis","Workout","Running","Soccer","Other"]
        return sportData
    }
    
    //TODO need to write using xml or SQL
    func getCategoryData() -> [NSString] {
        let categoryData = ["Pro","Advanced","Intermediate","Beginner","Other"]
        return categoryData
    }
    
    
    
    
}


