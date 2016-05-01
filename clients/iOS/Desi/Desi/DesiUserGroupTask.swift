//
//  DesiTask.swift
//  Desi
//
//  Created by Matthew Flickner on 8/19/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiUserGroupTask: PFObject, PFSubclassing {
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiUserGroupTask"
    }
    
    @NSManaged var userGroup: DesiUserGroup
    @NSManaged var task: DesiTask
    @NSManaged var isDesi: Bool
    @NSManaged var queueSpot: Int
    @NSManaged var updateCounter: Int

   
}
