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
        return "DesiTask"
    }

}
