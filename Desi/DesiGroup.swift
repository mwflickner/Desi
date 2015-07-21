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
    
    /*init(groupId: Int, groupName: String, users: [DesiUser], groupImg: Int) {
        self.groupId = groupId
        self.groupName = groupName
        self.users = users
        self.numberOfUsers = users.count
        self.desiIndex = 0
        self.theDesi = users[desiIndex]
        self.groupImg = groupImg
        super.init()
    }
    */
    
    
    
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
    
    func userSwap(index1: Int, index2: Int){
        var temp = self.groupMembers[index1]
        self.groupMembers[index1] = self.groupMembers[index2]
        self.groupMembers[index2] = temp
    }
    /*
    func randomDesi(){
        self.theDesi = userAt(Int(arc4random_uniform(UInt32(numberOfUsers))))
    }
    */
    
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
    
    
    func nextDesi(){
        ++self.desiIndex
        if (desiIndex < groupMembers.count){
            //self.theDesi = groupMembers[desiIndex]
        }
        else {
            //self.theDesi = groupMembers[0]
            //self.desiIndex = 0
        }
        
    }
    
}

//all of these functions need to update after being called

