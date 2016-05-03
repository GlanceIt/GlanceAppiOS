//
//  SpotTypeCell.swift
//  Glance
//
//  Created by Khorramzadeh, Mohammad on 4/21/16.
//  Copyright © 2016 Glance inc. All rights reserved.
//

import UIKit

class SpotTypeCell: UITableViewCell {

    @IBOutlet weak var spotTypeImage: UIImageView!
    @IBOutlet weak var spotType: UILabel!
    @IBOutlet weak var spotTypeDefinition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
