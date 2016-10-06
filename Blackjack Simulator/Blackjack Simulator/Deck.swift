//
//  Deck.swift
//  Blackjack Simulator
//
//  Created by Jordan Davis on 6/30/16.
//  Copyright © 2016 Jordan Davis. All rights reserved.
//

import Foundation

class Deck {
    
    var totalDeckCount: Int
    var deckArray = [String]()
    
    init() {
        totalDeckCount = 6
        initShoe(6)
    }
    
    func initShoe(totalDecks: Int) {
        totalDeckCount = totalDecks
        deckArray.removeAll()
        // this runs per DECK
        for _ in 1...totalDecks {
            // runs per CARD
            for x in 2...9 {
                // 4 cards per value
                for _ in 1...4 {
                    deckArray.append(String(x))
                }
            }
            // append all the 10s and faces
            for _ in 1...16 {
                deckArray.append("10")
            }
            // append the Aces, or 11's in my case
            // will handle 11's as Aces later.
            for _ in 1...4 {
                deckArray.append("11")
            }
        }
    }
    
    func shuffle() {
        // reset the deck with full values
        
    }
    
    
    
    func retrieveCard() -> Int {
        // pull a card from our deck
        var randCard = "1"
        if(deckArray.count > 0) {
            let randIndex = Int(arc4random_uniform(UInt32(deckArray.count - 1)))
            randCard = deckArray.removeAtIndex(randIndex)
        } else {
            randCard = "1"
        }
        
        if deckArray.count < (totalDeckCount * 52)  / 5 {
            initShoe(totalDeckCount)
        }
        
        return Int(randCard)!
    }
}