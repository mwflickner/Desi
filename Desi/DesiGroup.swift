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
    @NSManaged var groupMembers: [String]
    @NSManaged var numberOfUsers: Int
    @NSManaged var theDesi: DesiUserGroup!
    @NSManaged var desiIndex: Int
    @NSManaged var groupImg: PFFile
    
    
    func addMember(newMember: DesiUserGroup){
        self.groupMembers.append(newMember.username)
    }
    
    /*
    func removeMember(member: String){
        for groupies in self.groupMembers{
            if(groupies.user.username == member){
                groupMembers.removeAtIndex((indexofUser(member)))
            }
        }
    }
    */
    
    func userAt(index: Int) -> String{
        return self.groupMembers[index]
        //more to this
    }
    
    func indexofUser(username: String) -> Int{
        for var i = 0; i < numberOfUsers; ++i{
            if(username == self.groupMembers[i]){
                return i
            }
        }
        return -1
        //need to throw an error if user not found
    }
    
    func groupImage(imgNum: Int) -> UIImage? {
        switch imgNum {
            //add immages here to switch statement when we get group images
        default:
            return nil
        }
    }
    
    func changeGroupName(newName: String){
        self.groupName = newName
    }
    
    func setDesiIndex() {
        for var i = 0; i < self.groupMembers.count ; ++i {
            if self.groupMembers[i] == self.theDesi.username {
                self.desiIndex = i
            }
        }
    }
    
    func userSwap(index1: Int, index2: Int){
        var temp = self.groupMembers[index1]
        self.groupMembers[index1] = self.groupMembers[index2]
        self.groupMembers[index2] = temp
    }
    
    /*func randomDesi(){
        for username in self.groupMembers {
            if username == userAt(Int(arc4random_uniform(UInt32(numberOfUsers)))){
                username
            }
            
        }
    }*/

    
    func getUserFromDesi(distFromDesi: Int) -> String {
        //distFrom == 0 should return the Desi, 1 should return the next, 2 should return etc
        var index = desiIndex
        if (index < groupMembers.count - distFromDesi){
            return self.userAt(index + distFromDesi)
        }
        else {
            return self.userAt(index - (groupMembers.count - distFromDesi))
        }
    }
    
    func volunteer(userGroup: DesiUserGroup) {
        self.theDesi.isDesi = false
        self.theDesi.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("old Desi saved")
                println("about to start loop")
                userGroup.isDesi == true
                self.theDesi = userGroup
                
                //edits members array
                for var i = 0; i < self.groupMembers.count; ++i {
                    if self.groupMembers[i] == userGroup.username {
                        self.userSwap(self.desiIndex, index2: i)
                        self.theDesi = userGroup
                        break
                    }
                }
                println("basically done")
                
            } else {
                // There was a problem, check error.description
                println("UserGroup Error: \(error)")
                if error!.code == PFErrorCode.ErrorConnectionFailed.rawValue {
                    self.theDesi.saveEventually()
                }
            }
        })
    }
    
    
    func nextDesi(){
        
        ++self.desiIndex
        self.theDesi!.isDesi = false
        self.theDesi!.saveInBackgroundWithBlock({
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
        if (desiIndex < groupMembers.count){
            var desiQuery = DesiUserGroup.query()
            desiQuery!.includeKey("group.objectId")
            desiQuery!.whereKey("username", equalTo: self.groupMembers[desiIndex])
            desiQuery!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores. Swag.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let userGroups = objects as! [DesiUserGroup]
                            for ug in userGroups {
                                println("\(ug.group.objectId)")
                                if ug.group.objectId == self.objectId {
                                    self.theDesi = ug
                                    ug.isDesi = true
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
        else {
            var desiQuery = DesiUserGroup.query()
            desiQuery!.includeKey("group.objectId")
            desiQuery!.whereKey("username", equalTo: self.groupMembers[0])
            println("beginning else query")
            desiQuery!.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        // The find succeeded.
                        println("Successfully retrieved \(objects!.count) scores. Swag.")
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            let userGroups = objects as! [DesiUserGroup]
                            for ug in userGroups {
                                if ug.group.objectId == self.objectId {
                                    self.theDesi = ug
                                    ug.isDesi = true
                                }
                            }
                        }
                    }
                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!)")
                }
            }
            self.desiIndex = 0
        }
        
    }
    
}

//all of these functions need to update after being called

