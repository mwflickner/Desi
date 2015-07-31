//
//  DesiFriendList.swift
//  Desi
//
//  Created by Matthew Flickner on 7/30/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiFriendList: PFObject, PFSubclassing {
    
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiFriendList"
    }
    
    @NSManaged var owner: String
    //@NSManaged var ownerId: String
    @NSManaged var friendshipsIds: [String]
    @NSManaged var friendships: [DesiFriendship]
    @NSManaged var numberOfFriends: Int
    
    
}
