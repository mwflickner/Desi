//
//  DesiFriendship.swift
//  Desi
//
//  Created by Matthew Flickner on 7/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiFriendship: PFObject, PFSubclassing {
    
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiFriendship"
    }
    
    @NSManaged var user1: DesiUser
    @NSManaged var username1: String
    @NSManaged var user2: DesiUser
    @NSManaged var username2: String
    @NSManaged var friendshipAccepted: Bool
    
    
    
}
