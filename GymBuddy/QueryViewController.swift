//
//  QueryViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let myModel = QueryViewModel()
    
    //button
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var sportBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        okBtn.alpha = 0
        hideAllPicker()
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
    
    @IBAction func okBtnPressed(sender: UIButton) {
        
        if datePicker.alpha == 1 {
            println(myModel.dateToString(datePicker.date))
            timeDisplayLabel.text = "Time: " + myModel.dateToString(datePicker.date)

        }
        else if locationPickerView.alpha == 1 {
            println(myModel.getLocationData()[locationPickerView.selectedRowInComponent(0)])
            locationDisplayLabel.text = "Location: " + myModel.getLocationData()[locationPickerView.selectedRowInComponent(0)]

        }
        else if sportPickerView.alpha == 1 {
            println(myModel.getSportData()[sportPickerView.selectedRowInComponent(0)])
            sportDisplayLabel.text = "Sport: " + myModel.getSportData()[sportPickerView.selectedRowInComponent(0)]

        }
        else if categoryPickerView.alpha == 1 {
            println(myModel.getCategoryData()[categoryPickerView.selectedRowInComponent(0)])
            categoryDisplayLabel.text = "Category: " + myModel.getCategoryData()[categoryPickerView.selectedRowInComponent(0)]

        }
        
        hideAllPicker()
        okBtn.alpha = 0
        
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
    
    func hideAllPicker() {
        datePicker.alpha = 0
        locationPickerView.alpha = 0
        sportPickerView.alpha = 0
        categoryPickerView.alpha = 0
    }
    
    
    
}

