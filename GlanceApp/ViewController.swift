//
//  ViewController.swift
//  GlanceApp
//
//  Created by Khorramzadeh, Mohammad on 4/2/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultsTable: UITableView!
    let itemList:NSMutableArray = NSMutableArray()
    let GLANCE_SERVICE_ENDPOINT_URI = "http://ec2-52-89-65-158.us-west-2.compute.amazonaws.com:5000"
    let SPOTLIST_URL = "/spotlist"

    @IBAction func searchButtonTapped(sender: UIBarButtonItem) {

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
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
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
            
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // TODO: Make the GET call to Glance Service
        getSpotList()
        
        /*
        let data =
            "[\n" +
            "{\n" +
            "\"_id\": \"560098bba021987fd5938ec4\",\n" +
            "\"name\": \"Starbucks\",\n" +
            "\"aspects\": {\"Coffee\": {\"rating\": 2,\"count\": 218}} \n" +
            "},\n" +
            "{\n" +
            "\"_id\": \"560098bba021987fd5938ec4\",\n" +
            "\"name\": \"Starbucks2\",\n" +
            "\"aspects\": {\"Coffee\": {\"rating\": 3,\"count\": 248}} \n" +
            "}\n" +
            "]"

        let jsonData: NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!

        var jsonObj: AnyObject?
        do {
            jsonObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0))

        } catch {
            print(error)
        }

        if  jsonObj is Array<AnyObject> {
            for jsonSpot in jsonObj as! Array<AnyObject>{
                insertSpot(jsonSpot)
            }// for
        } // if

        resultsTable.reloadData()
        */
    }

    func insertSpot(spot: AnyObject) -> Void {
        let dataSet: NSMutableDictionary = NSMutableDictionary()

        let spotName = (spot["name"] as? String) ?? "" // to get rid of null
        let spotAspects  =  (spot["aspects"]  as AnyObject!)
        let coffeeRatingObj = (spotAspects["Coffee"] as AnyObject!)
        let coffeeRating = coffeeRatingObj["rating"] as? Int

        dataSet.setObject(spotName, forKey: "spotName")
        dataSet.setObject(coffeeRating!, forKey: "spotCoffeeRating")

        self.itemList.addObject(dataSet)
    }

    func addSpot(spot: NSDictionary) -> Void {
        let dataSet: NSMutableDictionary = NSMutableDictionary()
        
        let spotName = (spot["name"] as? String) ?? "" // to get rid of null
        let spotAspects  =  (spot["aspects"]  as AnyObject!)
        let staffRatingObj = (spotAspects["Staff"] as AnyObject!)
        let staffRating = staffRatingObj["rating"] as? Int
        let coffeeRatingObj = (spotAspects["Coffee"] as AnyObject!)
        let coffeeRating = coffeeRatingObj["rating"] as? Int
        let seatingRatingObj = (spotAspects["Seating"] as AnyObject!)
        let seatingRating = seatingRatingObj["rating"] as? Int
        
        dataSet.setObject(spotName, forKey: "spotName")
        dataSet.setObject(staffRating!, forKey: "spotStaffRating")
        dataSet.setObject(coffeeRating!, forKey: "spotCoffeeRating")
        dataSet.setObject(seatingRating!, forKey: "spotSeatingRating")
        
        self.itemList.addObject(dataSet)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.resultsTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let spotName = (itemList[indexPath.row].valueForKey("spotName") as? String)!
        let spotStaffRating = (itemList[indexPath.row].valueForKey("spotStaffRating") as? Int)!
        let spotCoffeeRating = (itemList[indexPath.row].valueForKey("spotCoffeeRating") as? Int)!
        let spotSeatingRating = (itemList[indexPath.row].valueForKey("spotSeatingRating") as? Int)!
        
        cell.textLabel?.text = "\(spotName) \nStaff: \(spotStaffRating)  Coffee: \(spotCoffeeRating)  Seating: \(spotSeatingRating)"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        print(itemList[indexPath.row].valueForKey("spotName"))
        print(itemList[indexPath.row].valueForKey("spotCoffeeRating"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

