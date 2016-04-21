//
//  SearchResultCell.swift
//  Glance
//
//  Created by Khorramzadeh, Mohammad on 4/20/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotMainImage: UIImageView!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var spotRatingsCollection: UICollectionView!
    var spotAspects: NSDictionary = NSDictionary()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotAspects.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let spotRatingsCell:SpotRatingsCollectionCell = self.spotRatingsCollection.dequeueReusableCellWithReuseIdentifier("spotRatingsCollectionCell", forIndexPath: indexPath) as! SpotRatingsCollectionCell

        let aspectName = (spotAspects.allKeys[indexPath.item] as? String)!
        let ratingObj = (spotAspects[aspectName] as? NSDictionary)!
        let aspectRating = (ratingObj["rating"] as? Int)!
        var ratingLabel = "*"

        for _ in 1 ..< aspectRating {
            ratingLabel += "*"
        }
        spotRatingsCell.ratingLabel?.text = "\(aspectName): \(ratingLabel)"

        return spotRatingsCell
    }
}
