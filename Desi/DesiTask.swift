//
//  DesiTask.swift
//  Desi
//
//  Created by Matthew Flickner on 8/19/15.
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
   
}
