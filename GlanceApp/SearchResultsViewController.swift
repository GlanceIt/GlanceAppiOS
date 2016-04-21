//
//  SearchResultsViewController.swift
//  GlanceApp
//
//  Created by Khorramzadeh, Mohammad on 4/2/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
//    , UICollectionViewDataSource, UICollectionViewDelegate
{
    
    @IBOutlet weak var resultsTable: UITableView!
    let itemList:NSMutableArray = NSMutableArray()
    let GLANCE_SERVICE_ENDPOINT_URI = "http://ec2-52-89-65-158.us-west-2.compute.amazonaws.com:5000"
    let SPOTLIST_URL = "/spotlist"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        getSpotList()
    }

    func getSpotList() {
        // Define server side script URL
        let scriptUrl = GLANCE_SERVICE_ENDPOINT_URI + SPOTLIST_URL
        
        // Add one parameter
        let urlWithParams = scriptUrl + ""
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("responseString = \(responseString)")
            
            dispatch_async(dispatch_get_main_queue(), {
                // Convert server json response to NSDictionary
                do {
                    if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        
                        // Print out dictionary
                        // print(convertedJsonIntoDict)
                        
                        // Get value by key
                        let results = convertedJsonIntoDict["result"] as? NSArray
                        
                        for spot in results!{
                            self.addSpot(spot as! NSDictionary)
                        }// for
                        
                        self.resultsTable.reloadData()
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            })
        }
        task.resume()
    }
    
    func addSpot(spot: NSDictionary) -> Void {
        let dataSet: NSMutableDictionary = NSMutableDictionary()
        dataSet.setObject(spot, forKey: "spotDetails")
        
        self.itemList.addObject(dataSet)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SearchResultCell = self.resultsTable.dequeueReusableCellWithIdentifier("searchResultCell") as! SearchResultCell
        
        let spotDetails = (itemList[indexPath.row].valueForKey("spotDetails") as? NSDictionary)!
        let spotName = (spotDetails["name"] as? String)!
//        let spotImageUrl = (spotDetails["Image"] as? String)!
//        let imageUrl = NSURL(string: spotImageUrl)
//        let spotImageData = NSData(contentsOfURL: imageUrl!)
//        let spotImage = UIImage(data: spotImageData!)

        let spotImage = UIImage(named: "coffee-\(indexPath.item).jpg")
        
        let spotAddressObj = (spotDetails["address"] as? NSDictionary)!
        let spotAddressStreet = (spotAddressObj["Street"] as? String)!
        let spotAddressCity = (spotAddressObj["City"] as? String)!
//        let spotAddressState = (spotAddressObj["State"] as? String)!
//        let spotAddressZip = (spotAddressObj["Zip"] as? Int)!

        cell.spotMainImage.image = spotImage
        cell.spotName.font = UIFont.boldSystemFontOfSize(14.0)
        cell.spotName.text = spotName
        cell.spotAddress.text = "\(spotAddressStreet), \(spotAddressCity)"

        let spotAspects = (spotDetails["aspects"] as? NSDictionary)!
        cell.spotAspects = spotAspects
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let spotDetails = (itemList[indexPath.row].valueForKey("spotDetails") as? NSDictionary)!
        let detailPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailPageViewController") as! DetailPageViewController
        detailPageViewController.spotDetails = spotDetails
        self.resultsTable.deselectRowAtIndexPath(indexPath, animated: false)
        navigationController?.pushViewController(detailPageViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

