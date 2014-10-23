//
//  ViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {


    @IBOutlet weak var dogeView: UIView!
    @IBOutlet weak var dogeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func dogEyeBlinder(sender: UIButton) {
        
        var color1 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        var color2 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        var color3 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        
        self.dogeView.backgroundColor = UIColor(red: color1, green: color2, blue: color3, alpha: 1)
    }
    

}

