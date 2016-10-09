//
//  CountdownViewController.swift
//  SafeTravel
//
//  Created by Nancy Yao on 10/8/16.
//  Copyright © 2016 MHacks8. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timerView.layer.borderWidth = 1
        timerView.layer.masksToBounds = false
        timerView.layer.cornerRadius = timerView.frame.height/2
        timerView.clipsToBounds = true
    }


}
