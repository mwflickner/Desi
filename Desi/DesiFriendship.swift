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
    
    @NSManaged var user: DesiUser
    @NSManaged var username: String
    
    @NSManaged var friend: DesiUser
    @NSManaged var friendFirstName: String
    @NSManaged var friendLastName: String
    @NSManaged var friendUsername: String
    
}
