//
//  ViewController.swift
//  SwiftTimerTutorial
//
//  Created by Mark Petherbridge on 2/26/16.
//  Copyright © 2016 iOS-Blog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var SwiftTimer = Timer()
    var SwiftCounter = 100
    
    @IBOutlet var countingLabel: UILabel!
    
    @IBAction func startButton(_ sender: AnyObject) {
        SwiftTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseButton(_ sender: AnyObject) {
        SwiftTimer.invalidate()
    }
    
    @IBAction func clearButton(_ sender: AnyObject) {
        SwiftTimer.invalidate()
        SwiftCounter = 100
        countingLabel.text = String(SwiftCounter)
    }
    
    func updateCounter() {
        SwiftCounter-=1
        countingLabel.text = String(SwiftCounter)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        countingLabel.text = String(timeString(time: TimeInterval(SwiftCounter)))
    }
    
}

