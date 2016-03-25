//
//  DesiTask.swift
//  Desi
//
//  Created by Matthew Flickner on 8/20/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiTask: PFObject, PFSubclassing {
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiTask"
    }
    
    @NSManaged var taskName: String
    @NSManaged var pointValue: Int
    @NSManaged var optOutCost: Int
    @NSManaged var repeats: Bool
    @NSManaged var taskType: String
    @NSManaged var rotationStyle: String
    @NSManaged var numberOfDesis: Int
    @NSManaged var taskDueDate: NSDate
    
}
