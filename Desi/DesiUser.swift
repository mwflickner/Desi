//
//  DesiUser.swift
//  Desi
//
//  Created by Matthew Flickner on 5/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiUser: PFUser, PFSubclassing {
    
    override class func initialize() {
        registerSubclass()
    }
    
    /*class func parseClassName() -> String {
        return "DesiUser"
    }
    */
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var userImg: PFFile
    @NSManaged var desiPoints: Int
    @NSManaged var userGroups: [DesiUserGroup]
    
    /*init(userName: String, firstName: String, lastName: String, userImg: Int) {
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.userImg = userImg
        //self.groupsIn = groupsIn
    }
    */
    
    
}
