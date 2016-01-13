//
//  SampleData.swift
//  Desi
//
//  Created by Matthew Flickner on 5/29/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//


import Foundation
import Parse
/*
var gameScore = PFObject(className:"GameScore")
/*
gameScore["score"] = 1337
gameScore["playerName"] = "Sean Plott"
gameScore["cheatMode"] = false

var mwflickner = PFObject(className:"DesiUser")
mwflickner["userName"] = "mwflickner"
mwflickner["firstName"] = "Matthew"
mwflickner["lastName"] = "Flickner"
*/




let mwflickner = DesiUser(userName: "mwflickner", firstName: "Matthew", lastName: "Flickner", userImg: 0)
let fratSutt = DesiUser(userName: "fratSutt", firstName: "Matt", lastName: "Sutton", userImg: 0)
let jhecht = DesiUser(userName: "jhecht", firstName: "Jessica", lastName: "Hecht", userImg: 0)

let knoxUsers = [mwflickner,fratSutt, jhecht]

let otherUsers = [mwflickner,jhecht]

let fortKnox = DesiGroup(groupId: 1, groupName: "Fort Knox", users: knoxUsers, groupImg: 0)
let other = DesiGroup(groupId: 2, groupName: "other", users: otherUsers, groupImg: 1)

let groupData = [fortKnox,other]
*/


