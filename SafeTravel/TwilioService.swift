//
//  TwilioService.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import Foundation

class Twilio {
    
    static let SID = "ACf3b4d0bce2d8d8c024445a775c4331f5"
    static let Secret = "xAFsAE51mX6HUsYe4ivgbxnkLrCiB630"
    
    let fromNumber = "4152226666"
    let toNumber = "2488605975"
    let messageDepart = "Leaving to my destination!"
    let messageArrive = "Arrived at my destination!"
    
    
    class Service {
        static func send(to: String, from: String, message: String, completed: @escaping (String?, Error?) -> ()) {
            var request = URLRequest(url: URL(string: "https://\(Twilio.SID):\(Twilio.Secret)@api.twilio.com/2010-04-01/Accounts/\(Twilio.SID)/SMS/Messages")!)
            
            request.httpMethod = "POST"
            request.httpBody = "From=\(Twilio.fromNumber)&To=\(Twilio.toNumber)&Body=\(message)".data(using: .utf8)
            
            // Build the completion block and send the request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                print("Finished")
                if let data = data, let responseDetails = String(data: data, encoding: .utf8) {
                    completed(responseDetails, nil)
                } else {
                    completed(nil, error)
                }
            }).resume()
        }
    }
}
