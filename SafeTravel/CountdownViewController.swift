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
        
         countdownLabel.text = String(timeString(time: TimeInterval(SwiftCounter)))
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
