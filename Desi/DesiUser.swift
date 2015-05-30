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
    //var isDesi: Bool
    //var groupsIn: [DesiGroup]
    
    init(userName: String, firstName: String, lastName: String) {
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        //self.isDesi = isDesi
        //self.groupsIn = groupsIn
    }
    
}
