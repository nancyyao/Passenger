//
//  Route.swift
//  SafeTravel
//
//  Created by Admin on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import CoreLocation

class Route: NSObject {
    var estTime: String?
    let start: String?
    let destination: CLLocation?
    let path: String?
    
    init(start: String, destination: CLLocation, estTime: String, path: String){
        self.start = start
        self.destination = destination
        self.estTime = estTime
        self.path = path
    }
    
}
