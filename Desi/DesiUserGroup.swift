//
//  DesiUserGroup.swift
//  Desi
//
//  Created by Matthew Flickner on 7/18/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiUserGroup: PFObject, PFSubclassing {
    
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiUserGroup"
    }
    
    @NSManaged var user: DesiUser
    @NSManaged var group: DesiGroup
    @NSManaged var username: String!
    //@NSManaged var userId: String
    //@NSManaged var groupId: String
    @NSManaged var isDesi: Bool
    @NSManaged var isGroupAdmin: Bool
    @NSManaged var groupPoints: Int
    
    
}
