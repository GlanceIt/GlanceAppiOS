//
//  DetailsPageViewController.swift
//  Glance
//
//  Created by Khorramzadeh, Mohammad on 4/14/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {

    @IBOutlet weak var spotNameLabel: UILabel!

    var spotIndex: String = ""
    var spotDetails: NSDictionary = [:];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotIndex = (spotDetails["index"] as? String)!
        let spotName = (spotDetails["name"] as? String)!
        let spotAspects = (spotDetails["aspects"] as? NSDictionary)!

        let spotStaffRatingObj = (spotAspects["Staff"] as? NSDictionary)!
        let spotStaffRating = (spotStaffRatingObj["rating"] as? Int)!
        let spotCoffeeRatingObj = (spotAspects["Coffee"] as? NSDictionary)!
        let spotCoffeeRating = (spotCoffeeRatingObj["rating"] as? Int)!
        let spotSeatingRatingObj = (spotAspects["Seating"] as? NSDictionary)!
        let spotSeatingRating = (spotSeatingRatingObj["rating"] as? Int)!

//        spotNameLabel?.text = "\(spotIndex)"
        spotNameLabel?.text = "\(spotIndex) \n\(spotName) \nStaff: \(spotStaffRating) \nCoffee: \(spotCoffeeRating) \nSeating: \(spotSeatingRating)"
        print("loaded \(spotIndex)")
        spotNameLabel?.numberOfLines = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
