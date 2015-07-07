//
//  RestOfGroupTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 7/6/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class RestOfGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restOfGroupLabel: UILabel!
    @IBOutlet weak var restOfGroupImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
