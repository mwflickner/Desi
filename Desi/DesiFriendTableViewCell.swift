//
//  DesiFriendTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 7/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class DesiFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var desiPointsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
