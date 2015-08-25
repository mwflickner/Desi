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
    @NSManaged var groupId: String
    @NSManaged var taskId: String
    
    func setDesiIndex() {
        for var i = 0; i < self.task.members.count; ++i {
            if (self.isDesi && self.task.members[i] == self.userGroup.username) {
                self.task.desiIndex = i
            }
        }
    }
    
    
    
    
    
    func dutyCompleted(){
        
        self.task.desiIndex = (++self.task.desiIndex)%self.task.members.count
        println("index is \(self.task.desiIndex)")
        self.isDesi = false
        self.theDesi.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("old Desi saved")
            } else {
                // There was a problem, check error.description
                println("UserGroup Error: \(error)")
                if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                    self.theDesi.saveEventually()
                }
            }
        })
        //if (desiIndex < groupMembers.count){
        var desiQuery = DesiUserGroupTask.query()
        desiQuery!.includeKey("userGroup")
        desiQuery!.includeKey("task")
        desiQuery!.whereKey("userGroup.username", equalTo: self.members[self.desiIndex])
        desiQuery!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // The find succeeded.
                    println("Successfully retrieved \(objects!.count) scores. Swag.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        let userGroupTasks = objects as! [DesiUserGroupTask]
                        for ugTask in userGroupTasks {
                            println("\(ugTask.task.objectId)")
                            if ugTask.task.objectId == self.objectId {
                                self.theDesi = ugTask
                                ugTask.isDesi = true
                            }
                        }
                        
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error!)")
            }
        }

   
}
