//
//  HelperMethods.swift
//  Desi
//
//  Created by Matthew Flickner on 1/19/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import Foundation
import UIKit
import Parse

let desiColor = UIColor(netHex:0xF04D4D)

func setErrorColor(textField: UITextField) {
    let errorColor : UIColor = UIColor.redColor()
    textField.layer.borderColor = errorColor.CGColor
    textField.layer.borderWidth = 1.5
}

func setSuccessColor(textField: UITextField) {
    let successColor : UIColor = UIColor( red: 0.3, green: 0.5, blue:0.3, alpha: 1.0 )
    textField.layer.borderColor = successColor.CGColor
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

func dateToString(date: NSDate) -> String {
    let timestamp = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    return timestamp
}

func findUserByUsername(username: String, block: PFQueryArrayResultBlock){
    let query = DesiUser.query()
    query!.whereKey("username", equalTo: username)
    query!.findObjectsInBackgroundWithBlock(block)
}

func getUserGroupsForGroup(group: DesiGroup, block: PFQueryArrayResultBlock){
    let userGroupQuery = DesiUserGroup.query()
    userGroupQuery!.includeKey("user")
    userGroupQuery!.includeKey("group")
    userGroupQuery!.whereKey("group", equalTo: group)
    userGroupQuery!.findObjectsInBackgroundWithBlock(block)
}

func getUserGroupTasksForTask(task: DesiTask, block: PFQueryArrayResultBlock){
    let userGroupTaskQuery = DesiUserGroupTask.query()
    userGroupTaskQuery?.includeKey("userGroup")
    userGroupTaskQuery?.includeKey("userGroup.user")
    userGroupTaskQuery?.includeKey("task")
    userGroupTaskQuery?.whereKey("task", equalTo: task)
    userGroupTaskQuery?.findObjectsInBackgroundWithBlock(block)
}

func createUserGroup(user: DesiUser, isAdmin: Bool, group: DesiGroup) -> DesiUserGroup {
    let newUserGroup: DesiUserGroup = DesiUserGroup()
    newUserGroup.group = group
    newUserGroup.user = user
    newUserGroup.isGroupAdmin = isAdmin
    newUserGroup.points = 0
    return newUserGroup
}
