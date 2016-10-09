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
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.topItem?.title = "Contacts"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = (user?.contactsArray!)?.count {
            return count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.contactImageView.setImageWith(NSURL(string: "http://www.2daysky.com/sharedContents/media/images/default.png") as! URL)
        cell.contactPhoneLabel.text = user?.phoneNumber
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
 }
}
