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
    @NSManaged var taskNames: [String]
    @NSManaged var taskIds: [String]
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

    
    /*func randomDesi(){
        for username in self.groupMembers {
            if username == userAt(Int(arc4random_uniform(UInt32(numberOfUsers)))){
                username
            }
            
        }
    }*/

    
}

//all of these functions need to update after being called

