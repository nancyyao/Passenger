//
//  ContactsViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit
import AFNetworking
import Firebase

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let currentUser = FIRAuth.auth()?.currentUser
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentUser != nil) {
            return user.contactsArray!.count
        }
        //number of contacts in user if defined; else 0
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.contactImageView.setImageWith(NSURL(string: "http://www.2daysky.com/sharedContents/media/images/default.png") as! URL)
        cell.contactPhoneLabel.text = user.phoneNumber
        return cell
    }
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    code
   // }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
 }
}
