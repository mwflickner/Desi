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
    
    //@NSManaged var theDesi: String
    @NSManaged var taskName: String
    //@NSManaged var members: [String]
    //@NSManaged var desiIndex: Int
    //@NSManaged var groupId : String
   
    /*
    func userSwap(index1: Int, index2: Int){
        let temp = self.members[index1]
        self.members[index1] = self.members[index2]
        self.members[index2] = temp
    }
    
    func setDesiIndex() {
        for var i = 0; i < self.members.count; ++i {
            if (self.members[i] == self.theDesi) {
                self.desiIndex = i
            }
        }
    }
    
    func userAt(index: Int) -> String{
        return self.members[index]
        //more to this
    }
    
    func indexOfUser(username: String) -> Int{
        for var i = 0; i < members.count; ++i{
            if(username == self.members[i]){
                return i
            }
        }
        return -1
        //need to throw an error if user not found
    }
    
    func getUserFromDesi(distFromDesi: Int) -> String {
        //distFrom == 0 should return the Desi, 1 should return the next, 2 should return etc
        let index = self.desiIndex
        if (index < self.members.count - distFromDesi){
            return self.userAt(index + distFromDesi)
        }
        else {
            return self.userAt(index - (self.members.count - distFromDesi))
        }
    }
    */
    
                

    
}
