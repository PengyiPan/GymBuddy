//
//  MatchingViewController.swift
//  GymBuddy
//
//  Created by Pengyi Pan on 10/22/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import UIKit

class MatchingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    

    var myData: Array<AnyObject> = []
    
    let myModel = MatchingViewModel()
    
    var receivedQueryTime = ""
    var receivedQueryLocation = ""
    var receivedQuerySport = ""
    var receivedQueryCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeQuery()
        //myData = ["asdasd","asdasdddd","sssss","kkkkk"]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell") as UITableViewCell
        
//        let album = self.albums[indexPath.row]
//        cell.textLabel?.text = album.title
//        cell.imageView?.image = UIImage(named: "Blank52")
//        
//        // Get the formatted price string for display in the subtitle
//        let formattedPrice = album.price
//        
//        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
//        let urlString = album.thumbnailImageURL
//        
//        // Check our image cache for the existing key. This is just a dictionary of UIImages
//        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
//        var image = self.imageCache[urlString]
//        
//        
//        if( image == nil ) {
//            // If the image does not exist, we need to download it
//            var imgURL: NSURL = NSURL(string: urlString)
//            
//            // Download an NSData representation of the image at the URL
//            let request: NSURLRequest = NSURLRequest(URL: imgURL)
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
//                if error == nil {
//                    image = UIImage(data: data)
//                    
//                    // Store the image in to our cache
//                    self.imageCache[urlString] = image
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
//                            cellToUpdate.imageView?.image = image
//                        }
//                    })
//                }
//                else {
//                    println("Error: \(error.localizedDescription)")
//                }
//            })
//            
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), {
//                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
//                    cellToUpdate.imageView?.image = image
//                }
//            })
//        }
        
        cell.textLabel.text =  myModel.makeCellTitleString(myData[indexPath.row] as PostedWorkoutRecord)
        cell.detailTextLabel?.text = myModel.makeCellDetailString(myData[indexPath.row] as PostedWorkoutRecord)
        
        return cell
    }
    
   
    
    //the animation effect
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
//        var rowData: NSDictionary = self.myData[indexPath.row] as NSDictionary
//        
//        var name: String = rowData["trackName"] as String
//        var formattedPrice: String = rowData["formattedPrice"] as String
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "alllalla"
        alert.message = "SB"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    

    
    func makeQuery() {
        myModel.makeDatabaseQuery(receivedQueryTime, receivedQueryLocation: receivedQueryLocation, receivedQuerySport: receivedQuerySport, receivedQueryCategory: receivedQueryCategory,viewCtrl:self)
     
    }
    
    func didGetQueryResult(resultList:Array<PostedWorkoutRecord>) {

        //print all for debug
//        for record in resultList {
//            println(record.record_id!)
//            println(record.time_start!)
//            println(record.time_end!)
//            println(record.location!)
//            println(record.sport_type!)
//            println(record.sport_sub_type!)
//        }
        
        //TODO: sort the input list
        
        myData = resultList
        
        myTableView.reloadData()
    
    }
    
    
  
    
}

