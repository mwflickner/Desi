//
//  HelperMethods.swift
//  Desi
//
//  Created by Matthew Flickner on 1/19/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import Foundation
import UIKit


func setErrorColor(textField: UITextField) {
    let errorColor : UIColor = UIColor.redColor()
    textField.layer.borderColor = errorColor.CGColor
    textField.layer.borderWidth = 1.5
}

func removeErrorColor(textField: UITextField) {
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}

func borderTableView(tableView: UITableView) {
    let borderColor: UIColor = UIColor.blackColor()
    tableView.layer.borderColor = borderColor.CGColor
    tableView.layer.borderWidth = 1.5
}

func isValidUsername(testStr: String) -> Bool {
    let usernameRegEx = "^[a-z0-9_-]{4,16}$"
    let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
    return usernameTest.evaluateWithObject(testStr)
}