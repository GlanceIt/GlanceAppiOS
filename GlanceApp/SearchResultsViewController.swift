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
    let SEARCH_URL = "/search"
    var spotType = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        getSpotList()
    }

    func getSpotList() {
        // Define server side script URL
        let scriptUrl = GLANCE_SERVICE_ENDPOINT_URI + SEARCH_URL
        
        // Add one parameter
        let urlWithParams = scriptUrl + ""
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to POST
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        var weights = NSDictionary()
        switch self.spotType {
            case "Coffee Places":
                weights = ["coffeeWeight" : 100]
            case "Study Places":
                weights = ["wifiWeight" : 10, "seatingWeight": 100, "parkingWeight": 2]
            case "Hangout Places":
                weights = ["seatingWeight" : 100, "parkingWeight": 10]
            case "Dating Places":
                weights = ["staffWeight" : 10, "seatingWeight": 100]
            default:
                weights = NSDictionary()
        }

        var postBody = NSDictionary()
        postBody = ["weights" : weights]

        do {
            let jsonPostBody = try NSJSONSerialization.dataWithJSONObject(postBody, options: .PrettyPrinted)
            request.HTTPBody = jsonPostBody
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
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
                    if let results = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                        
                        // Print out dictionary
                        // print(convertedJsonIntoDict)
                        
                        // Get value by key
                        
                        for spot in results{
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
        self.itemList.addObject(spot)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SearchResultCell = self.resultsTable.dequeueReusableCellWithIdentifier("searchResultCell") as! SearchResultCell
        
        let spotDetails = (itemList[indexPath.row] as? NSDictionary)!
        let spotName = (spotDetails["name"] as? String)!
        let spotIndex = (spotDetails["index"] as? String)!

        // Use image url when images are stored on the server side
//        let spotImageUrl = (spotDetails["Image"] as? String)!
//        let imageUrl = NSURL(string: spotImageUrl)
//        let spotImageData = NSData(contentsOfURL: imageUrl!)
//        let spotImage = UIImage(data: spotImageData!)

        // Temporarily store images locally
        let spotImage = UIImage(named: "SpotImages/\(spotIndex).jpg")
        
        let spotAddressObj = (spotDetails["address"] as? NSDictionary)!
        let spotAddressStreet = (spotAddressObj["Street"] as? String)!
        let spotAddressCity = (spotAddressObj["City"] as? String)!
//        let spotAddressState = (spotAddressObj["State"] as? String)!
//        let spotAddressZip = (spotAddressObj["Zip"] as? Int)!

        let spotDistanceObj =
            (spotDetails["dist"] as? NSDictionary)!
        let spotDistanceInMeters = (spotDistanceObj["calculated"] as? Double)!
        let spotDistanceInMiles = spotDistanceInMeters / 1600
        var spotDistanceString = NSString(format:"%.1f", spotDistanceInMiles)
        if spotDistanceString == "0.0" {
           spotDistanceString = NSString(format:"%.2f", spotDistanceInMiles)
        }

        cell.spotMainImage.image = spotImage
        cell.spotName.font = UIFont.boldSystemFontOfSize(14.0)
        cell.spotName.text = spotName
        cell.spotAddress.text = "\(spotAddressStreet), \(spotAddressCity)"

        let spotOverallRatingObj = (spotDetails["Overall"] as? NSDictionary)!
        let spotAspects = (spotDetails["aspects"] as? NSDictionary)!
        let spotOverallRating = (spotOverallRatingObj["rating"] as? Int)!
        let spotOverallRatingStarsImage = UIImage(named: "StarImages/\(spotOverallRating)-stars.png")
        cell.spotOverallRatingStars.image = spotOverallRatingStarsImage
        cell.spotAspects = spotAspects
        cell.spotDistance.text = "\(spotDistanceString) mi"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let spotDetails = (itemList[indexPath.row] as? NSDictionary)!
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

