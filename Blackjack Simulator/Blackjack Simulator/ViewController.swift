//
//  ViewController.swift
//  Blackjack Simulator
//
//  Created by Jordan Davis on 6/26/16.
//  Copyright © 2016 Jordan Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userCardOne: UISlider!
    @IBOutlet weak var userCardTwo: UISlider!
    @IBOutlet weak var dealerUpCard: UISlider!
    var userWinCount: Double = 0.0
    var userLossCount: Double = 0.0
    var userPushCount: Double = 0.0
    var totalHands: Double = 1000.0
    var recommendedAction: String = ""
    var buttonColor = UIColor.clearColor()
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var simButton: UIButton!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var statsTextField: UITextView!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBAction func numOfSimsEnd(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func userSliderOne_ValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        oneLabel.text = "\(currentValue)"
    }
    
    @IBAction func userSliderTwo_ValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        twoLabel.text = "\(currentValue)"
    }
    
    @IBAction func dealerSlider_ValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        threeLabel.text = "\(currentValue)"
    }
    
    @IBAction func numOfSims(sender: UITextField) {
        if Double(sender.text!) != nil {
            totalHands = Double(sender.text!)!
        } else {
            totalHands = 1000
        }
        sender.resignFirstResponder()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        simButton.layer.cornerRadius = 6
        loadingIcon.hidden = true
        buttonColor = simButton.backgroundColor!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitStats() {
        userWinCount = 0.0
        userLossCount = 0.0
        userPushCount = 0.0
        
    }
    @IBAction func SimButton_TouchDown(sender: UIButton) {
        simButton.backgroundColor = UIColor.blueColor()
    }
    
    @IBAction func SimButton_TouchCancel(sender: UIButton) {
        simButton.backgroundColor = buttonColor
    }
    @IBAction func simButton_Click(sender: AnyObject) {
        loadingIcon.startAnimating()
        loadingIcon.hidden = false

        
        InitStats()
        var i = 1.0
        var extraHands = 0.0

        while i <= totalHands {
            var sim: BlackjackSimulator
            sim = BlackjackSimulator()

            // start the sim
            sim.setUserHand(Int(oneLabel.text!)!, cardTwo: Int(twoLabel.text!)!)
            sim.setDealerHand(Int(threeLabel.text!)!)
            sim.runSim()
            
            if sim.userWins && !sim.push {
                // we win! do some tallying
                userWinCount += 1
            } else if !sim.userWins && !sim.push {
                // dealer wins
                userLossCount += 1
            } else {
                // good ole push.
                userPushCount += 1
            }
            
            if sim.userHandTwo > 0 {
                // means second hand in play
                sim.checkSecondHandWinner()

                if sim.userWins && !sim.push {
                    // we win! do some tallying
                    userWinCount += 1
                } else if !sim.userWins && !sim.push {
                    // dealer wins
                    userLossCount += 1
                } else {
                    // good ole push.
                    userPushCount += 1
                }
                extraHands += 1.0
            }
            
            recommendedAction = sim.recommendedAction
            i += 1
        }
        statsTextField.text = "\(recommendedAction) \n" +
        "Win PCT: \((userWinCount / (totalHands + extraHands)) * 100). \n" +
        "Pushes: \(userPushCount)"
        loadingIcon.hidden = true
        loadingIcon.stopAnimating()
        simButton.backgroundColor = buttonColor
    }
    
}

