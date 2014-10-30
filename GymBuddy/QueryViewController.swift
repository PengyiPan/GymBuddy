//
//  QueryViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController {
    
    let myModel = QueryViewModel()
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var sportBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var locationDisplayLabel: UILabel!
    @IBOutlet weak var sportDisplayLabel: UILabel!
    @IBOutlet weak var categoryDisplayLabel: UILabel!
    @IBOutlet weak var locationPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        datePicker.alpha = 0
        okBtn.alpha = 0
        locationPickerView.alpha = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set to only support portrait, too lazy to do the landscape shit
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    
    @IBAction func timeBtnPressed(sender: UIButton) {
        println("timeBtnPressed")
        okBtn.alpha = 1
        datePicker.alpha = 1
        
    }
    
    @IBAction func locationBtnPressed(sender: UIButton) {
        myModel.fillLocationPicker(locationPickerView)
        locationPickerView.alpha = 1
    }
    
    @IBAction func sportBtnPressed(sender: UIButton) {
    }
    
    @IBAction func categoryBtnPressed(sender: UIButton) {
    }
    
    @IBAction func okBtnPressed(sender: UIButton) {
        println(myModel.dateToString(datePicker.date))
        datePicker.alpha = 0
        okBtn.alpha = 0
        timeDisplayLabel.text = "Time: " + myModel.dateToString(datePicker.date)
    }
    
    
    
}

