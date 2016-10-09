//
//  CountdownViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    var address:String!
    var eta:String!
    var countdown:String!
    var messageComposer:MessageComposer?
    

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBAction func onLeavingButton(_ sender: AnyObject) {
        if (messageComposer?.canSendText())! {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer?.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC!, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    @IBAction func onHereButton(_ sender: AnyObject) {
        if (messageComposer?.canSendText())! {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer?.configuredMessageComposeViewController2()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC!, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageComposer = MessageComposer(address: self.address, eta: self.eta)
        
//        countdownLabel.text = String(timeString(time: TimeInterval(SwiftCounter)))
        addressLabel.text = address
        etaLabel.text = eta
        
        
    }
    var SwiftTimer = Timer()
    var SwiftCounter = 100
    
    
    @IBAction func startButton(_ sender: AnyObject) {
        SwiftTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseButton(_ sender: AnyObject) {
        SwiftTimer.invalidate()
    }
    
    @IBAction func clearButton(_ sender: AnyObject) {
        SwiftTimer.invalidate()
        SwiftCounter = 100
        countdownLabel.text = String(SwiftCounter)
    }
    
    func updateCounter() {
        SwiftCounter-=1
        countdownLabel.text = String(SwiftCounter)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
