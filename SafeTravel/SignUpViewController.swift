//
//  SignUpViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    var user: User!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    let currentUser = FIRAuth.auth()?.currentUser

    @IBAction func onSubmit(_ sender: UIButton) {
        user.name = nameTextField.text
        user.phoneNumber = phoneTextField.text
        
    }
}
