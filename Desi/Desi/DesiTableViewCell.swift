//
//  TextFieldTableViewCell.swift
//  Desi
//
//  Created by Matthew Flickner on 7/31/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class DesiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
