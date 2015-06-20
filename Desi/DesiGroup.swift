//
//  DesiGroup.swift
//  Desi
//
//  Created by Matthew Flickner on 5/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class DesiGroup: NSObject {
    var groupId: Int
    var groupName: String
    var users: [DesiUser]
    var numberOfUsers: Int
    var theDesi: DesiUser
    var desiIndex: Int
    var groupImg: Int
    
    init(groupId: Int, groupName: String, users: [DesiUser], groupImg: Int) {
        self.groupId = groupId
        self.groupName = groupName
        self.users = users
        self.numberOfUsers = users.count
        self.desiIndex = 0
        self.theDesi = users[desiIndex]
        self.groupImg = groupImg
        super.init()
    }
    
    
    func addMember(newMember: DesiUser){
        self.users.append(newMember)
    }
    
    func removeMember(member: String){
        for user in self.users{
            if(user.userName == member){
                users.removeAtIndex((indexofUser(member)))
            }
        }
    }
    
    func userAt(index: Int) -> DesiUser{
        return self.users[index]
    }
    
    func indexofUser(username: String) -> Int{
        for var i = 0; i < numberOfUsers; ++i{
            if(username == self.users[i].userName){
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
        var temp = self.users[index1]
        self.users[index1] = self.users[index2]
        self.users[index2] = temp
    }
    
    func randomDesi(){
        self.theDesi = userAt(Int(arc4random_uniform(UInt32(numberOfUsers))))
    }
    
    func nextDesi(){
        ++self.desiIndex
        if (desiIndex < users.count){
            self.theDesi = users[desiIndex]
        }
        else {
            self.theDesi = users[0]
            self.desiIndex = 0
        }
        
    }
}

