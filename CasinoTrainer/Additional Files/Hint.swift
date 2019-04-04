//
//  Hint.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 13.02.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

class Hint {
    
    static func giveNextCardHint(cards: [Card]) -> String {
        
        var points = countPoints(cards: cards)
        var hint: String
        
        
        
        return ""
    }
    
    static func chanceForUniqueNumber() -> Float {
        return Float(4/52)
    }
    static func chanceForTen() -> Float {
        return Float(16/52)
    }
    static func countPoints(cards: [Card]) -> Int {
        var cardPoints = 0
        for c in cards {
            cardPoints += c.giveValue()
        }
        return cardPoints
    }
    static func chances() -> [Int:Float] {
        let answer = [
            1: chanceForUniqueNumber(),
            2: chanceForUniqueNumber(),
            3: chanceForUniqueNumber(),
            4: chanceForUniqueNumber(),
            5: chanceForUniqueNumber(),
            6: chanceForUniqueNumber(),
            7: chanceForUniqueNumber(),
            8: chanceForUniqueNumber(),
            9: chanceForUniqueNumber(),
            10: chanceForTen(),
            11: chanceForUniqueNumber()
        ]
        return answer
    }
    
}
