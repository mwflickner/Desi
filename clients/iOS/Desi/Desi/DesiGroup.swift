//
//  DesiGroup.swift
//  Desi
//
//  Created by Matthew Flickner on 5/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiGroup: PFObject, PFSubclassing {
    
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiGroup"
    }
    
    @NSManaged var groupName: String
    @NSManaged var numberOfUsers: Int
    @NSManaged var groupImg: PFFile
    @NSManaged var isPrivate: Bool
    @NSManaged var groupDescription: String


}