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

class LoginViewController: UIViewController {
    var user: User!
    
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
    
    // Sign up
    func signUp(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                print("Error with signUp:", error)
                self.alert(title: "Alert:", message: "Error signing up, please try again")
            } else {
                print("User signed up successfully")
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                let user = User.init(email: email, password: password, name: nil, phoneNumber: nil, currLocation: nil, contactsArray: [])
            }
        }
    }
    @IBAction func onSignUpButton(_ sender: UIButton) {
        print("hit sign up button")
        signUp(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    
    // Log in
    func logIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                print("Error with logIn:", error)
                self.alert(title: "Alert:", message: "Error logging in, please try again")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                //do something with user
            }
        }
    }
    @IBAction func onLogInButton(_ sender: UIButton) {
        print("hit log in button")
        logIn(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    // Sign out
    func signOut() {
        try! FIRAuth.auth()!.signOut()
        self.performSegue(withIdentifier: "LogOut", sender: nil)
    }
    
}
