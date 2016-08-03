//
//  SearchViewController.swift
//  Glance
//
//  Created by Khorramzadeh, Mohammad on 4/16/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var spotTypesTable: UITableView!
    let spotTypes = ["Coffee Places", "Study Places", "Hangout Places", "Dating Places"]
    let spotTypeDefinitions = ["Good Coffee, Good Seating", "Good Seating, Good Wifi", "Goof Seating, Good Ambience", "Good Ambience, Good Service"]
    let spotTypeImages = ["SpotTypeImages/coffee.jpg", "SpotTypeImages/study.jpg", "SpotTypeImages/hangout.jpg", "SpotTypeImages/dating.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spotTypesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SpotTypeCell = self.spotTypesTable.dequeueReusableCellWithIdentifier("spotTypeCell")! as! SpotTypeCell

        cell.spotTypeImage.image = UIImage(named: spotTypeImages[indexPath.item])
        cell.spotTypeDefinition?.text = spotTypeDefinitions[indexPath.item]
        cell.spotTypeDefinition?.numberOfLines = 2

        cell.spotType?.font = UIFont.boldSystemFontOfSize(18.0)
        cell.spotType?.text = spotTypes[indexPath.item]
        cell.spotTypeDefinition?.numberOfLines = 1

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:SpotTypeCell = self.spotTypesTable.cellForRowAtIndexPath(indexPath) as! SpotTypeCell

        let searchResultsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("searchResultsViewController") as! SearchResultsViewController
        //searchResultsViewController.spotDetails = spotDetails
        searchResultsViewController.spotType = cell.spotType.text!
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }

}
