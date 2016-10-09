//
//  User.swift
//  SafeTravel
//
//  Created by Admin on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import CoreLocation
import Mantle

class User: MTLModel {
    
    var name: String?
    var phoneNumber: String?
    var contactsArray: [NSObject]?
    
    init(name: String?, phoneNumber: String?,
        contactsArray: [NSObject]?){
        self.name = name
        self.phoneNumber = phoneNumber
        self.contactsArray = contactsArray
        super.init()
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(dictionary dictionaryValue: [AnyHashable : Any]!) throws {
        try! super.init(dictionary: dictionaryValue)
    }
    
}

extension User: MTLJSONSerializing {
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["name": "name",
                "phoneNumber": "phone_number"]
    }
}
