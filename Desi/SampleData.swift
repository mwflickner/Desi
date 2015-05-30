//
//  SampleData.swift
//  Desi
//
//  Created by Matthew Flickner on 5/29/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import Foundation

let mwflickner = DesiUser(userName: "mwflickner", firstName: "Matthew", lastName: "Flickner")
let fratSutt = DesiUser(userName: "fratSutt", firstName: "Matt", lastName: "Sutton")
let jhecht = DesiUser(userName: "jhecht", firstName: "Jessica", lastName: "Hecht")

let knoxUsers = [mwflickner,fratSutt]

let otherUsers = [mwflickner,jhecht]

let fortKnox = DesiGroup(groupId: 1, groupName: "Fort Knox", users: knoxUsers)
let other = DesiGroup(groupId: 2, groupName: "other", users: otherUsers)

let groupData = [fortKnox,other]