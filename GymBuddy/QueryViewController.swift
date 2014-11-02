//
//  QueryViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit
import CoreData

class QueryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let myModel = QueryViewModel()
    var enoughInfoChecker = [false,false,false,false]
    
    //button
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var sportBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var findMatchButton: UIButton!
    
    //picker
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var sportPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    //display label
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var locationDisplayLabel: UILabel!
    @IBOutlet weak var sportDisplayLabel: UILabel!
    @IBOutlet weak var categoryDisplayLabel: UILabel!
    
    
    //the array to keep track of the current input state
    var inputLog = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        okBtn.alpha = 0
        hideAllPicker()
        loadInputLog()
        updateDisplayLabel()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set to only support portrait, too lazy to do the landscape shit
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    
    @IBAction func timeBtnPressed(sender: UIButton) {
        hideAllPicker()
        okBtn.alpha = 1
        datePicker.alpha = 1
    }
    
    @IBAction func locationBtnPressed(sender: UIButton) {
        hideAllPicker()
        okBtn.alpha = 1
        locationPickerView.alpha = 1
        
    }
    
    @IBAction func sportBtnPressed(sender: UIButton) {
        hideAllPicker()
        okBtn.alpha = 1
        sportPickerView.alpha = 1
    }
    
    @IBAction func categoryBtnPressed(sender: UIButton) {
        hideAllPicker()
        okBtn.alpha = 1
        categoryPickerView.alpha = 1
    }
    
    @IBAction func findMatchBtnPressed(sender: UIButton) {
        saveAllInput()
        println("Find Match Button Pressed, query info sent:")
        println(self.labelTextToOutputText(timeDisplayLabel.text!))
        println(self.labelTextToOutputText(locationDisplayLabel.text!))
        println(self.labelTextToOutputText(sportDisplayLabel.text!))
        println(self.labelTextToOutputText(categoryDisplayLabel.text!))
        
    }
    
    @IBAction func okBtnPressed(sender: UIButton) {
        
        if datePicker.alpha == 1 {
            //println(myModel.dateToString(datePicker.date))
            timeDisplayLabel.text = "Time: " + myModel.dateToString(datePicker.date)
            enoughInfoChecker[0] = true

        }
        else if locationPickerView.alpha == 1 {
            //println(myModel.getLocationData()[locationPickerView.selectedRowInComponent(0)])
            locationDisplayLabel.text = "Location: " + myModel.getLocationData()[locationPickerView.selectedRowInComponent(0)]
            enoughInfoChecker[1] = true

        }
        else if sportPickerView.alpha == 1 {
            //println(myModel.getSportData()[sportPickerView.selectedRowInComponent(0)])
            sportDisplayLabel.text = "Sport: " + myModel.getSportData()[sportPickerView.selectedRowInComponent(0)]
            enoughInfoChecker[2] = true

        }
        else if categoryPickerView.alpha == 1 {
            //println(myModel.getCategoryData()[categoryPickerView.selectedRowInComponent(0)])
            categoryDisplayLabel.text = "Category: " + myModel.getCategoryData()[categoryPickerView.selectedRowInComponent(0)]
            enoughInfoChecker[3] = true

        }
        
        hideAllPicker()
        okBtn.alpha = 0
        tryToShowFindMatchBtn()
        
    }
    
    //how many components in one row
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //how many rows
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPickerView{
            return myModel.getLocationData().count
        }
        else if pickerView == sportPickerView {
            return myModel.getSportData().count
        }
        else if pickerView == categoryPickerView {
            return myModel.getCategoryData().count
        }
        else {
            return 0
        }
    
    }
    
    //picker data here
    func pickerView(pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String!{
        if pickerView == locationPickerView{
            return myModel.getLocationData()[row]
        }
        else if pickerView == sportPickerView {
            return myModel.getSportData()[row]
        }
        else if pickerView == categoryPickerView {
            return myModel.getCategoryData()[row]
        }
        else {
            return ""
        }
        
    }
    
    //Hide all pickers
    func hideAllPicker() {
        datePicker.alpha = 0
        locationPickerView.alpha = 0
        sportPickerView.alpha = 0
        categoryPickerView.alpha = 0
        findMatchButton.alpha = 0
    }
    
    //If all four info are filled, show findMatch Button
    func tryToShowFindMatchBtn() {
        if !contains(enoughInfoChecker,false) {
            findMatchButton.alpha = 1
        }
    }
    
    //Save the current query info into coredata
    func saveAllInput() {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("QueryLog",inManagedObjectContext:managedContext)
        
        let newInput = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        
        //3
        let timeToSave = myModel.dateToString(datePicker.date)
        let locationToSave = myModel.getLocationData()[locationPickerView.selectedRowInComponent(0)]
        let sportToSave = myModel.getSportData()[sportPickerView.selectedRowInComponent(0)]
        let categoryToSave = myModel.getCategoryData()[categoryPickerView.selectedRowInComponent(0)]
        
        newInput.setValue(timeToSave, forKey: "time")
        newInput.setValue(locationToSave, forKey: "location")
        newInput.setValue(sportToSave, forKey: "sport")
        newInput.setValue(categoryToSave, forKey: "category")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }

    }
    
    //Load the last query input
    func loadInputLog() {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"QueryLog")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
             inputLog = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    //update the display label according to the loaded query input from last time
    func updateDisplayLabel() {
        var timeStr = ""
        var locStr = ""
        var spStr = ""
        var caStr = ""
        
        if (inputLog.count > 0) {
            timeStr = inputLog.last!.valueForKey("time") as String
            locStr = inputLog.last!.valueForKey("location") as String
            spStr = inputLog.last!.valueForKey("sport") as String
            caStr = inputLog.last!.valueForKey("category") as String
            
            enoughInfoChecker[0] = true
            enoughInfoChecker[1] = true
            enoughInfoChecker[2] = true
            enoughInfoChecker[3] = true
            
            timeDisplayLabel.text = "Time: " + timeStr
            locationDisplayLabel.text = "Location: " + locStr
            sportDisplayLabel.text = "Sport: " + spStr
            categoryDisplayLabel.text = "Category: " + caStr
            
            tryToShowFindMatchBtn()
        }
        
        
        
    }
    
    //convert the text in label to pure info String
    func labelTextToOutputText (inputString: String) -> String {
        return inputString.componentsSeparatedByString(": ")[1]
    }
    
    // for debugging purpose
    func printLog() {
            for res in inputLog {
                println(res.valueForKey("time"))
                println(res.valueForKey("location"))
                println(res.valueForKey("sport"))
                println(res.valueForKey("category"))
                println("End of printLog")
                println("        ")
        }
    
    }
    

    
    
}

