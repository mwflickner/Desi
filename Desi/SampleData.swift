//
//  SampleData.swift
//  Desi
//
//  Created by Matthew Flickner on 5/29/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import Foundation

let mwflickner = DesiUser(userName: "mwflickner", firstName: "Matthew", lastName: "Flickner", userImg: 0)
let fratSutt = DesiUser(userName: "fratSutt", firstName: "Matt", lastName: "Sutton", userImg: 0)
let jhecht = DesiUser(userName: "jhecht", firstName: "Jessica", lastName: "Hecht", userImg: 0)

let knoxUsers = [mwflickner,fratSutt]

let otherUsers = [mwflickner,jhecht]

let fortKnox = DesiGroup(groupId: 1, groupName: "Fort Knox", users: knoxUsers, groupImg: 0)
let other = DesiGroup(groupId: 2, groupName: "other", users: otherUsers, groupImg: 1)

let groupData = [fortKnox,other]

let appUser = mwflickner