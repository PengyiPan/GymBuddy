//
//  AddPostViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 12/6/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//
import UIKit
import CoreData

class AddPostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let myModel = AddPostViewModel()
    var enoughInfoChecker = [false,false,false,false,false]
    
    var receivedQueryTime = ""
    var receivedQueryLocation = ""
    var receivedQuerySport = ""
    var receivedQueryCategory = ""
    
    var startTime: NSDate = NSDate()
    var endTime: NSDate = NSDate()
    
    //button
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var sportBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var postButton: UIButton!

    
    //picker
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var sportPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var datePicker2: UIDatePicker!
    
    //display label
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var locationDisplayLabel: UILabel!
    @IBOutlet weak var sportDisplayLabel: UILabel!
    @IBOutlet weak var categoryDisplayLabel: UILabel!
    
    
    //the array to keep track of the current input state

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        okBtn.alpha = 0
        hideAllPicker()
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
            var user:UserData = fetchResults[0];
            println(user.net_id)
        }
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
        timeDisplayLabel.text = ""
        enoughInfoChecker[0] = false
        enoughInfoChecker[4] = false
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "Select starting time"
        alert.addButtonWithTitle("OK")
        alert.show()
        
        okBtn.alpha = 1
        datePicker.minimumDate = startTime
        datePicker.alpha = 1
    }
    
    func datePicker2Called(){
 
        hideAllPicker()
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "Select ending time"
        alert.addButtonWithTitle("OK")
        alert.show()
        
        okBtn.alpha = 1
        datePicker2.minimumDate = startTime
        datePicker2.alpha = 1
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
    

    
    @IBAction func postBtnPressed(sender: UIButton) {
        
        
        var toPostStartTime = myModel.dateToPostString(self.startTime)
        var toPostEndTime = myModel.dateToPostString(self.endTime)
        var toPostLocation = self.labelTextToOutputText(locationDisplayLabel.text!)
        var toPostSport = self.labelTextToOutputText(sportDisplayLabel.text!)
        var toPostCategory = self.labelTextToOutputText(categoryDisplayLabel.text!)
        
        println("Post Btn Pressed, new post info sent:")

        println(toPostStartTime)
        println(toPostEndTime)
        println(toPostLocation)
        println(toPostSport)
        println(toPostCategory)
        
    }
    
    @IBAction func okBtnPressed(sender: UIButton) {
        
        if datePicker.alpha == 1 {
            //println(myModel.dateToString(datePicker.date))
            
            self.startTime = datePicker.date
            enoughInfoChecker[0] = true
            
        }
        else if datePicker2.alpha == 1 {
            
            self.endTime = datePicker2.date
            timeDisplayLabel.text = "Time: " + myModel.dateToString(self.startTime) + " - " + myModel.dateToString(self.endTime)
            enoughInfoChecker[4] = true
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
        tryToShowPostBtn()
        
        if (enoughInfoChecker[4] == false) {
            self.datePicker2Called()
        }
        
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
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
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
        datePicker2.alpha = 0
        locationPickerView.alpha = 0
        sportPickerView.alpha = 0
        categoryPickerView.alpha = 0
        postButton.alpha = 0
    }
    
    //If all four info are filled, show findMatch Button
    func tryToShowPostBtn() {
        if !contains(enoughInfoChecker,false) {
            postButton.alpha = 1
        }
    }
    
    
    //convert the text in label to pure info String
    func labelTextToOutputText (inputString: String) -> String {
        return inputString.componentsSeparatedByString(": ")[1]
    }
    
//    // for debugging purpose
//    func printLog() {
//        for res in inputLog {
//            println(res.valueForKey("time"))
//            println(res.valueForKey("location"))
//            println(res.valueForKey("sport"))
//            println(res.valueForKey("category"))
//            println("End of printLog")
//            println("        ")
//        }
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "backToMatchSegue") {
            var destinationVC = segue.destinationViewController as MatchingViewController;
            destinationVC.receivedQueryTime = self.receivedQueryTime
            destinationVC.receivedQueryLocation = self.receivedQueryLocation
            destinationVC.receivedQuerySport = self.receivedQuerySport
            destinationVC.receivedQueryCategory = self.receivedQueryCategory
            
            
        }
    }
    
    
    
    
}
