//
//  MessageComposer.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import Foundation
import MessageUI

let textMessageRecipients = ["1-248-860-5975"] // for pre-populating the recipients list (optional, depending on your needs)

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "Hey friend - Just sending a text message in-app using Swift!"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
//// TEXT MESSAGES
////Text/Start trip Button
//let textButton = UIButton(frame: CGRect(x: 200, y: 500, width: 100, height: 100))
//textButton.setTitle("Send Message", for: .normal)
//textButton.backgroundColor = UIColor.green
//textButton.addTarget(self, action: #selector(onSendText), for: .touchUpInside)
//self.view.addSubview(textButton)

//// SEND TEXT MESSAGES
//func onSendText(_ sender:UIButton) {
//    // Make sure the device can send text messages
//    if (messageComposer.canSendText()) {
//        // Obtain a configured MFMessageComposeViewController
//        let messageComposeVC = messageComposer.configuredMessageComposeViewController()
//        
//        // Present the configured MFMessageComposeViewController instance
//        // Note that the dismissal of the VC will be handled by the messageComposer instance,
//        // since it implements the appropriate delegate call-back
//        present(messageComposeVC, animated: true, completion: nil)
//    } else {
//        // Let the user know if his/her device isn't able to send text messages
//        let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
//        errorAlert.show()
//    }
//}
