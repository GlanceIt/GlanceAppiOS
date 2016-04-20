//
//  SearchResultCell.swift
//  Glance
//
//  Created by Khorramzadeh, Mohammad on 4/20/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotMainImage: UIImageView!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var spotCoffeeRating: UILabel!
    @IBOutlet weak var spotSeatingRating: UILabel!
    @IBOutlet weak var spotStaffRating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
