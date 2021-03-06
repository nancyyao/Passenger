//
//  SignUpViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/9/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Mantle
import FirebaseDatabase


class SignUpViewController: UIViewController {
    var user: User!
    
    lazy var firebase: FIRDatabase = {
        return FIRDatabase.database()
    }()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
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
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (firebaseUser, error) in
            guard let firebaseUser = firebaseUser else {
                print("Error with signUp:", error)
                self.alert(title: "Alert:", message: "Error signing up, please try again")
                return
            }
            print("User signed up successfully")
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            let user = User.init(name: self.nameTextField.text, phoneNumber: self.phoneTextField.text, contactsArray: [])
            let json = try! MTLJSONAdapter.jsonDictionary(fromModel: user)
            self.firebase.reference(withPath: "/users").child(firebaseUser.uid).setValue(json, withCompletionBlock: { (error, ref) in
                print("user \(user) ref \(ref)")
            })
        }
    }
    @IBAction func onSignUpButton(_ sender: UIButton) {
        print("hit sign up button")
        signUp(email: emailTextField.text!, password: passwordTextField.text!)
    }
}
