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
    @IBOutlet weak var spotDistance: UILabel!
    @IBOutlet weak var spotOverallRatingStars: UIImageView!

    var spotAspects: NSDictionary = NSDictionary()
    var spotOverall: NSDictionary = NSDictionary()
    var aspectWeights: NSDictionary = NSDictionary()

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

        let sortedAspects = self.aspectWeights.keysSortedByValueUsingComparator{
            (obj1, obj2) in
            let x = obj1 as! NSNumber
            let y = obj2 as! NSNumber
            return y.compare(x)
        }

        var aspectName = (sortedAspects[indexPath.item] as? String)!
        let ratingObj = (spotAspects[aspectName] as? NSDictionary)!
        let aspectRating = (ratingObj["rating"] as? Int)!
        let aspectRatingCount = (ratingObj["count"] as? Int)!
        let aspectNameStartIndex = aspectName.startIndex
        aspectName.replaceRange(aspectNameStartIndex...aspectNameStartIndex, with: String(aspectName[aspectNameStartIndex]).uppercaseString)

        spotRatingsCell.ratingLabel?.text = "\(aspectName)"
        spotRatingsCell.ratingLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        spotRatingsCell.ratingCountLabel?.text = "(\(aspectRatingCount))"
        let starsImage = UIImage(named: "StarImages/\(aspectRating)-stars.png")
        spotRatingsCell.ratingStars.image = starsImage

        return spotRatingsCell
    }
}
