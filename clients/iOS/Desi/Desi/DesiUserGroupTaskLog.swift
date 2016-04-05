//
//  DesiTaskLog.swift
//  Desi
//
//  Created by Matthew Flickner on 2/18/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiUserGroupTaskLog: PFObject, PFSubclassing {
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiUserGroupTaskLog"
    }

    @NSManaged var userGroupTask: DesiUserGroupTask
    @NSManaged var actionMessage: String
    @NSManaged var actionType: String
    
    func actionTypeToVerb() -> String {
        if actionType == "completion" {
            return "completed"
        }
        if actionType == "volunteer" {
            return "volunteered"
        }
        return "opted-out"
    }
}
