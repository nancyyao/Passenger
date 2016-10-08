//
//  User.swift
//  SafeTravel
//
//  Created by Admin on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
//import CoreLocation

class User: NSObject {
    
    var email: String?
    var password: String?
    var name: String?
    var phoneNumber: String?
    var currLocation: String?
    var contactsArray: [NSObject]?
    
    init(email: String?, password: String?,
         name: String?, phoneNumber: String?,
         currLocation: String?, contactsArray: [NSObject]?){
        self.email = email
        self.password = password
        self.name = name
        self.phoneNumber = phoneNumber
        self.contactsArray = contactsArray
        
    }
    
}
