//
//  QueryViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/29/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class QueryViewModel {
    

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
    
    //TODO need to write using xml or SQL
    func getLocationData() -> [NSString] {
        let locationData = ["East","West","Brodie","Bla","Bllla"]
        return locationData
    }
    
    //TODO need to write using xml or SQL
    func getSportData() -> [NSString] {
        let sportData = ["Golf","Swimming","Workout","Football", "Basketball"]
        return sportData
    }
    
    //TODO need to write using xml or SQL
    func getCategoryData() -> [NSString] {
        let categoryData = ["Newbie","Noob","Median","High","Pro"]
        return categoryData
    }
    


}


