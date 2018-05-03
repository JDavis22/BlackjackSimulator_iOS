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
	var buttonColor = UIColor.clear
    
	@IBOutlet weak var numOfSimsTextField: UITextField!
	@IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var simButton: UIButton!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var statsTextField: UITextView!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
	
    @IBAction func numOfSimsEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
	
	@IBAction func userSliderOne_Changed(_ sender: UISlider) {
		let currentValue = Int(sender.value)
		
		oneLabel.text = "\(currentValue)"
	}
	
    @IBAction func userSliderTwo_ValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        twoLabel.text = "\(currentValue)"
    }
    
    @IBAction func dealerSlider_ValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        threeLabel.text = "\(currentValue)"
    }
    
    @IBAction func numOfSims(_ sender: UITextField) {
        if Double(sender.text!) != nil {
            totalHands = Double(sender.text!)!
        } else {
            totalHands = 1000
        }
        sender.resignFirstResponder()
        
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
		super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        simButton.layer.cornerRadius = 6
		loadingIcon.isHidden = true
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
    @IBAction func SimButton_TouchDown(_ sender: UIButton) {
		simButton.backgroundColor = UIColor.blue
    }
    
    @IBAction func SimButton_TouchCancel(_ sender: UIButton) {
        simButton.backgroundColor = buttonColor
    }
    @IBAction func simButton_Click(_ sender: AnyObject) {
        loadingIcon.startAnimating()
		loadingIcon.isHidden = false
		simButton.setTitle("Simulating...", for: .normal)
		if Double(numOfSimsTextField.text!) != nil {
			totalHands = Double(numOfSimsTextField.text!)!
		} else {
			totalHands = 1000
		}
        
        InitStats()
        var i = 1.0
        var extraHands = 0.0

        while i <= totalHands {
            var sim: BlackjackSimulator
            sim = BlackjackSimulator()

            // start the sim
			sim.setUserHand(cardOne: Int(oneLabel.text!)!, cardTwo: Int(twoLabel.text!)!)
			sim.setDealerHand(upCard: Int(threeLabel.text!)!)
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
		simButton.setTitle("Simulate!", for: .normal)
        statsTextField.text = "\(recommendedAction) \n" +
        "Win PCT: \((userWinCount / (totalHands + extraHands)) * 100). \n" +
        "Pushes: \(userPushCount)"
		loadingIcon.isHidden = true
        loadingIcon.stopAnimating()
        simButton.backgroundColor = buttonColor
    }
    
}

