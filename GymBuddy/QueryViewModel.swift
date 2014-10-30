//
//  QueryViewModel.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/29/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class QueryViewModel {
    
    let pickerData = ["Mozzarella","Gorgonzola","Provolone","Brie","Maytag Blue","Sharp Cheddar","Monterrey Jack","Stilton","Gouda","Goat Cheese", "Asiago"]	

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
    
    func fillLocationPicker(picker: UIPickerView){
        class customDataSource : NSObject, UIPickerViewDelegate{
            func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
                return pickerData[row]
            }
        }
        picker.delegate = customDataSource()
    }

}


