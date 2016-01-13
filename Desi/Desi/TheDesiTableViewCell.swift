//
//  TheDesiTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 6/20/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class TheDesiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var theDesiNameLabel: UILabel!
    @IBOutlet weak var theDesiImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
