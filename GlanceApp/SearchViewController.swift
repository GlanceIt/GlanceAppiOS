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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SpotTypeCell = self.spotTypesTable.dequeueReusableCellWithIdentifier("spotTypeCell")! as! SpotTypeCell

        cell.spotTypeImage.image = UIImage(named: "coffee-1.jpg")
        cell.spotTypeDefinition?.text = "Coffee Places"
        cell.spotTypeDefinition?.numberOfLines = 1
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchResultsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("searchResultsViewController") as! SearchResultsViewController
        //searchResultsViewController.spotDetails = spotDetails
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }

}
