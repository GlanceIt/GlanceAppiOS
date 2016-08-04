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
    @IBOutlet weak var overallRating: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var overallStars: UIImageView!
    @IBOutlet weak var spotRatingsTable: UITableView!

    var spotIndex: String = ""
    var spotDetails: NSDictionary = [:];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotIndex = (spotDetails["index"] as? String)!
        let spotName = (spotDetails["name"] as? String)!
        let spotAddressObj = (spotDetails["address"] as? NSDictionary)!
        let spotAddressStreet = (spotAddressObj["street"] as? String)!
        let spotAddressCity = (spotAddressObj["city"] as? String)!

        let spotAspects = (spotDetails["aspects"] as? NSDictionary)!

        var aspectRatingLabel = ""
        var aspectsCount = 1
        for aspectName in spotAspects.keyEnumerator() {
            let aspectObj = spotAspects[aspectName as! String] as! NSDictionary
            let aspectRating = (aspectObj["rating"] as? Int)!
            let aspectRatingCount = (aspectObj["count"] as? Int)!
            let ratingLabel = getRatingLabel(aspectRating)
            aspectRatingLabel += "\(aspectName) \(ratingLabel) (\(aspectRatingCount))\n"
            aspectsCount = aspectsCount + 1
        }

        let overallStarsImage = UIImage(named: "StarImages/3-stars.png")
        overallStars.image = overallStarsImage

        spotNameLabel?.text = "\(spotName)"
        address?.text = "\(spotAddressStreet), \(spotAddressCity)"
//        \nStaff: \(spotStaffRating) \nCoffee: \(spotCoffeeRating) \nSeating: \(spotSeatingRating)"
        ratings?.text = aspectRatingLabel
        ratings?.numberOfLines = aspectsCount
        print("loaded \(spotIndex)")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = self.spotRatingsTable.deq
        let cell:UITableViewCell = self.spotRatingsTable.dequeueReusableCellWithIdentifier("spotRatingsCell")!
        cell.textLabel!.text = (spotDetails["index"] as? String)!
        cell.detailTextLabel!.text = (spotDetails["index"] as? String)!
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRatingLabel(rating: Int) -> String {
        var ratingLabel = "*"

        for _ in 1 ..< rating {
            ratingLabel += "*"
        }
        for _ in 0 ..< 5 - rating {
            ratingLabel += " "
        }

        return ratingLabel
    }
}
