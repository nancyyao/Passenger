//
//  LoginViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Mantle
import FirebaseDatabase


class LoginViewController: UIViewController {
    var user: User!
    
    lazy var firebase: FIRDatabase = {
        return FIRDatabase.database()
    }()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Alert for errors logging in or signing up
    private func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
       // Log in
    func logIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                print("Error with logIn:", error)
                self.alert(title: "Alert:", message: "Error logging in, please try again")
            } else {
                print("User logged in successfully")
                Twilio.Service.send(to: Twilio.toNumber, from: Twilio.fromNumber, message: Twilio.messageArrive, completed: { (msg: String?, error: Error?) in
                    if (error != nil) {
                        
                    } else {
                        print("error: \(error)")
                    }
                })
//                let json = try! MTLJSONAdapter.jsonDictionary(fromModel: user as! MTLJSONSerializing!)
//                self.firebase.reference(withPath: "/users").parent(firebase
                
                
                self.performSegue(withIdentifier: "LoginSegue2", sender: nil)
                //do something with user
            }
        }
    }
    @IBAction func onLogInButton(_ sender: UIButton) {
        print("hit log in button")
        logIn(email: emailTextField.text!, password: passwordTextField.text!)
    }
}
