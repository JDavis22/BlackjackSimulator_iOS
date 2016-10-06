//
//  BlackjackSimulator.swift
//  Blackjack Simulator
//
//  Created by Jordan Davis on 6/27/16.
//  Copyright © 2016 Jordan Davis. All rights reserved.
//
/** CURRENTLY: 
    app is breaking if dealer has 10.. no idea why.
 **/
import Foundation

class BlackjackSimulator {
    
    var userCardOne: Int
    var userCardTwo: Int
    var dealerUpCard: Int
    var dealerDownCard: Int
    var recommendedAction: String
    var stay: Bool = false
    var secondStay: Bool = false
    var isDealerStay: Bool = false
    var isDealerBJ: Bool = false
    
    var userHand: Int = 0
    var dealerHand: Int = 0
    
    var userHandTwo: Int = 0
    
    var userBust = false
    var dealerBust = false
    
    var userWins = false
    var push = false

    var myShoe: Deck
    
    init() {
        userCardOne = 0
        userCardTwo = 0
        dealerUpCard = 0
        dealerDownCard = 0
        recommendedAction = ""
        userHand = 0
        dealerHand = 0
        isDealerStay = false
        stay = false
        myShoe = Deck()
    }
    
    
    func setUserHand(cardOne: Int, cardTwo: Int) {
        userCardOne = cardOne
        userCardTwo = cardTwo
        userHand = userCardOne + userCardTwo

    }
    
    func setDealerHand(upCard: Int) {
        dealerUpCard = upCard
        dealerDownCard = myShoe.retrieveCard()
        dealerHand = dealerUpCard + dealerDownCard
    }
    
    func runSim() {
        myShoe.initShoe(6)
        
        while !stay {
            doUserAction(&userHand, isSecondHand: false)
        }
        
        while !isDealerStay {
            doDealerAction()
        }
        
        if(userHand > 21) {
            userBust = true
        }
        
        if(dealerHand > 21) {
            dealerBust = true
        }
        
        checkWinner()
    }
    
    // user decision    
    func doUserAction(inout userHand: Int, isSecondHand: Bool) {
        var canProceed = true
        
        // player does nothing if Dealer has BJ
        if dealerHasBlackjack() {
            canProceed = false
        }
        
        if shouldSplit() && canProceed {
            splitHand()
            canProceed = false
        }
        
        if(canProceed) {
            if userHand == 11 && dealerUpCard <= 10 {
                doubleDown(&userHand, isSecondHand: isSecondHand)
                canProceed = false
            } else if userHand == 10 && dealerUpCard <= 9 {
                doubleDown(&userHand, isSecondHand: isSecondHand)
                canProceed = false
            } else if userHand == 9 && dealerUpCard >= 3 && dealerUpCard <= 6 {
                doubleDown(&userHand, isSecondHand: isSecondHand)
                canProceed = false
            } else if userCardOne == 11 || userCardTwo == 11 {
                // user has one ace, two aces would have triggered a split.
                if (userHand == 13  || userHand == 14) && (dealerUpCard == 5 || dealerUpCard == 6) {
                    doubleDown(&userHand, isSecondHand: false)
                    canProceed = false
                } else if (userHand == 15 || userHand == 16) &&
                    (dealerUpCard >= 4 && dealerUpCard <= 6) {
                    doubleDown(&userHand, isSecondHand: false)
                    canProceed = false
                } else if (userHand == 17 || userHand == 18) && (dealerUpCard >= 3 && dealerUpCard <= 6) {
                    doubleDown(&userHand, isSecondHand: false)
                    canProceed = false
                } else if userHand <= 17 {
                    Hit(&userHand)
                    canProceed = false
                }
                
                
            }
        }
        
        if(canProceed) {
            // These are the always moves!
            if userHand <= 11 {
                Hit(&userHand)
                canProceed = false
            } else if userHand >= 17 {
                Stay(isSecondHand)
                canProceed = false
            }
        }
        
        if(canProceed) {
            // these are the decisions based on dealer card.
            if dealerUpCard >= 7 && userHand >= 12 && userHand <= 16 {
                Hit(&userHand)
                canProceed = false
            } else if dealerUpCard <= 6 && userHand >= 12 &&  userHand <= 16 {
                Stay(isSecondHand)
                canProceed = false
            }
        }
    }
    
    // Check if dealer has blackjack and terminate the hand
    func dealerHasBlackjack() -> Bool {
        if ((dealerUpCard == 10 && dealerDownCard == 11) ||
            (dealerDownCard == 11 && dealerUpCard == 10)) {
            stay = true
            isDealerBJ = true
            
            return true
        }
        return false
    }
    
    // SPLIT ACTIONS
    
    func shouldSplit() -> Bool {
        var shouldSplit = false
        if userCardOne == userCardTwo {
            switch userCardOne {
            case 2,
                 3:
                if dealerUpCard <= 7 {
                    shouldSplit = true
                }
                break
            case 4:
                if dealerUpCard == 5 || dealerUpCard == 6 {
                    shouldSplit = true
                }
                break
            case 5:
                break
            case 6:
                if dealerUpCard <= 6 {
                    shouldSplit = true
                }
                break
            case 7:
                if dealerUpCard <= 7 {
                    shouldSplit = true
                }
                break
            case 8:
                shouldSplit = true
                break
            case 9:
                if dealerUpCard != 7 && dealerUpCard != 10 && dealerUpCard != 11 {
                    shouldSplit = true
                }
                break
            case 10:
                shouldSplit = false
                break
            case 11:
                shouldSplit = true
                break
            default:
                shouldSplit = false
                break
            }
        }
        return shouldSplit
    }
    
    func splitHand() {
        if recommendedAction == "" {
            setAction("You should Split!")
        }
        
        // create a new hand based on seperate cards
        userHand = userCardOne
        userHandTwo = userCardTwo
        
        if userCardTwo == 11 && userCardOne == 11 {
            Hit(&userHand)
            Hit(&userHandTwo)
        } else {
            while !stay && !isDealerBJ{
                splitHandActions(&userHand, isSecondHand: false)
            }
            
            while !secondStay && !isDealerBJ {
                splitHandActions(&userHandTwo, isSecondHand: true)
            }
            
            
        }
    }

    func splitHandActions(inout userHand: Int, isSecondHand: Bool) {
        if dealerHasBlackjack() {
            return
        }
        
        if userHand == 9 && dealerUpCard >= 3 && dealerUpCard <= 6 {
            doubleDown(&userHand, isSecondHand: isSecondHand)
            return
        }
        
        // These are the always moves!
        if userHand <= 11 {
            Hit(&userHand)
            return
        } else if userHand >= 17 {
            Stay(isSecondHand)
            return
        }
        
        // these are the decisions based on dealer card.
        
        if dealerUpCard >= 7 && userHand >= 12 && userHand <= 16 {
            Hit(&userHand)
            return
        } else if dealerUpCard <= 6 && userHand >= 12 &&  userHand <= 16 {
            Stay(isSecondHand)
            return
        }
    }
    
    func Hit(inout userHand: Int) {
        if recommendedAction == "" {
            setAction("You should Hit!")
        }
        
        let newCard = myShoe.retrieveCard()
        
        // the card is an Ace
        if newCard == 11 {
            if newCard + userHand >= 17 && newCard + userHand <= 21 {
                userHand += newCard
            } else {
                userHand += 1
            }
        } else {
            userHand += newCard
        }
    }
    
    func Stay(isSecondHand: Bool) {
        if recommendedAction == "" {
            setAction("You should Stay!")
        }
        
        if(isSecondHand) {
        secondStay = true
        } else {
            stay = true
        }
    }
    
    func doubleDown(inout userHand: Int, isSecondHand: Bool) {
        if recommendedAction == "" {
            setAction("Double Down!")
        }
        Hit(&userHand)
        
        if isSecondHand {
            secondStay = true
        } else {
            stay = true
        }

    }
    
    func doDealerAction() {
        // dealer is easy
        if dealerHand <= 16 {
            dealerHit()
        } else {
            dealerStay()
        }
    }
    
    func dealerHit() {
        let newCard = myShoe.retrieveCard()
        
        // the card is an Ace
        if newCard == 11 {
            if newCard + dealerHand >= 18 && newCard + dealerHand <= 21 {
                dealerHand += newCard
            } else {
                dealerHand += 1
            }
        } else {
            dealerHand += newCard
        }
    }
    
    func dealerStay() {
        isDealerStay = true
    }
    
    func setAction(action: String) {
        recommendedAction = action
    }
    
    func checkWinner() {
        if(userBust) {
            // dealer auto wins
            userWins = false

        } else if dealerBust {
            // player auto wins
            userWins = true
        } else if userHand == dealerHand {
            // push
            push = true

        } else if userHand > dealerHand {
            // player wins
            userWins = true
        } else {
            // dealer wins.. :(
            userWins = false
        }
    }
    
    func checkSecondHandWinner() {
        if userHandTwo > 0 {
            if(userBust) {
                // dealer auto wins
                userWins = false
                
            } else if dealerBust {
                // player auto wins
                userWins = true
            } else if userHandTwo == dealerHand {
                // push
                push = true
                
            } else if userHand > dealerHand {
                // player wins
                userWins = true
            } else {
                // dealer wins.. :(
                userWins = false
            }
        }
    }
    
    
}