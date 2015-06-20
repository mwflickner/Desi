//
//  DesiUser.swift
//  Desi
//
//  Created by Matthew Flickner on 5/24/15.
//  Copyright (c) 2015 Desi. All rights reserved.
//

import UIKit

class DesiUser: NSObject {
    var userName: String
    //var password: String
    var firstName: String
    var lastName: String
    var userImg: Int
    //var isDesi: Bool
    //var groupsIn: [DesiGroup]
    
    init(userName: String, firstName: String, lastName: String, userImg: Int) {
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.userImg = userImg
        //self.isDesi = isDesi
        //self.groupsIn = groupsIn
    }
    
    func userImage(imgNum: Int) -> UIImage? {
        switch imgNum {
            //add immages here to switch statement when we get user images
        default:
            return nil
        }
    }
    
}
