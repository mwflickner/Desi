//
//  ProfileMainTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 7/23/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class ProfileMainTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var desiPointsLabel: UILabel!
    @IBOutlet weak var viewFriendsButton: UIButton!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
