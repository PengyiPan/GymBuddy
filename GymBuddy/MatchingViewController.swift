//
//  MatchingViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class MatchingViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var receivedQueryTime = ""
    var receivedQueryLocation = ""
    var receivedQuerySport = ""
    var receivedQueryCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDatabaseQuery()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeDatabaseQuery() {
        var bodyData = "query= SELECT * FROM PostedWorkOutRecord"
        
        
        let URL: NSURL = NSURL(string: "http://pengyipan.com/service.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                var output = NSString(data: data, encoding: NSUTF8StringEncoding) // new output variable
                println(output!)
                self.textView.text = output!
                //TODO: parse received Json data
                
        }
    }
    
  
    
}

