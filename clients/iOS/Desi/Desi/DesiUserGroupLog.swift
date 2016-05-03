//
//  DesiUserGroupLog.swift
//  Desi
//
//  Created by Matthew Flickner on 5/1/16.
//  Copyright © 2016 Desi. All rights reserved.
//

import UIKit
import Parse

class DesiUserGroupLog: PFObject, PFSubclassing {
    override class func initialize() {
        registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "DesiUserGroupLog"
    }
    
    @NSManaged var userGroup: DesiUserGroup
    @NSManaged var task: DesiTask
    @NSManaged var actionMessage: String
    @NSManaged var actionType: String
    @NSManaged var points: Int
    @NSManaged var receiver: DesiUserGroup?
    
    func actionTypeToVerb() -> String? {
        if actionType == "completion" {
            return "completed"
        }
        if actionType == "volunteer" {
            return "volunteered"
        }
        if actionType == "opt-out" {
            return "opted-out"
        }
        if actionType == "creatition" {
            return "created"
        }
        if actionType == "deletion" {
            return "deleted"
        }
        if actionType == "removal" {
            return "removed"
        }
        return nil
    }
}
