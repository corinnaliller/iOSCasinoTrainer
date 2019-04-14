//
//  Hint.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 13.02.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

class Hint {
    let chances: BlackJackChances
    
    init() {
        self.chances = BlackJackChances()
    }
    
    func giveNextCardHint(cards: [Card]) -> String {
        let points = countPoints(cards: cards)
        var hint: String = ""
        let cardChances = chances.playerChances[points]!
        for c in cardChances {
            hint = "\(hint)\(c.key.description()) Points: \(MathHelper.roundFloat(number: c.value)) %\n"
        }
        return hint
    }
    func giveBankChances(bankCard: Card) -> String {
        let bankChances = chances.bankChances[bankCard.picture]!
        var hint: String = ""
        for c in bankChances {
            hint = "\(hint)\(c.key.description()) Points: \(MathHelper.roundFloat(number: c.value)) %\n"
        }
        return hint
    }
    func countPoints(cards: [Card]) -> Int {
        var cardPoints = 0
        for c in cards {
            cardPoints += c.giveValue()
        }
        return cardPoints
    }
    
}
enum BlackJackPoints: Int {
    case underSeventeen = 16, seventeen, eightteen, nineteen, twenty, twentyone, bust, blackjack
    func description() -> String {
        switch self {
        case .underSeventeen:
            return "<17"
        case .seventeen:
            return "17"
        case .eightteen:
            return "18"
        case .nineteen:
            return "19"
        case .twenty:
            return "20"
        case .twentyone:
            return "21"
        case .bust:
            return "bust"
        case .blackjack:
            return "Blackjack"
        }
    }
}
class BlackJackChances {
    let playerChances: [Int:[BlackJackPoints:Float]]
    let bankChances: [Rank:[BlackJackPoints:Float]]
    
    
    init() {
        self.playerChances = [
            4 : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            5 : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            6 : [
                .underSeventeen : Float(12/13),
                .seventeen : Float(1/13),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            7 : [
                .underSeventeen : Float(8/13),
                .seventeen : Float(4/13),
                .eightteen : Float(1/13),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            8 : [
                .underSeventeen : Float(7/13),
                .seventeen : Float(1/13),
                .eightteen : Float(4/13),
                .nineteen : Float(1/13),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            9 : [
                .underSeventeen : Float(6/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(4/13),
                .twenty : Float(1/13),
                .twentyone : Float(0),
                .bust: Float(0)
            ],
            10 : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(4/13),
                .twentyone : Float(1/13),
                .bust: Float(0)
            ],
            11 : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(4/13),
                .bust: Float(0)
            ],
            12 : [
                .underSeventeen : Float(4/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(4/13)
            ],
            13 : [
                .underSeventeen : Float(3/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(5/13)
            ],
            14 : [
                .underSeventeen : Float(2/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(6/13)
            ],
            15 : [
                .underSeventeen : Float(1/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(7/13)
            ],
            16 : [
                .underSeventeen : Float(0),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(8/13)
            ],
            17 : [
                .underSeventeen : Float(0),
                .seventeen : Float(0),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(9/13)
            ],
            18 : [
                .underSeventeen : Float(0),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(10/13)
            ],
            19 : [
                .underSeventeen : Float(0),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(1/13),
                .twentyone : Float(1/13),
                .bust: Float(11/13)
            ],
            20 : [
                .underSeventeen : Float(0),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(1/13),
                .bust: Float(12/13)
            ],
            21 : [
                .underSeventeen : Float(0),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(1)
            ]
        ]
        self.bankChances = [
            .ace : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(1/13),
                .twentyone : Float(4/13),
                .bust: Float(0),
                .blackjack: Float(4/13)
            ],
            .two : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .three : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .four : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .five : [
                .underSeventeen : Float(1),
                .seventeen : Float(0),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .six : [
                .underSeventeen : Float(12/13),
                .seventeen : Float(1/13),
                .eightteen : Float(0),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .seven : [
                .underSeventeen : Float(8/13),
                .seventeen : Float(4/13),
                .eightteen : Float(1/13),
                .nineteen : Float(0),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .eight : [
                .underSeventeen : Float(7/13),
                .seventeen : Float(1/13),
                .eightteen : Float(4/13),
                .nineteen : Float(1/13),
                .twenty : Float(0),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .nine : [
                .underSeventeen : Float(6/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(4/13),
                .twenty : Float(1/13),
                .twentyone : Float(0),
                .bust: Float(0),
                .blackjack: Float(0)
            ],
            .ten : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(4/13),
                .twentyone : Float(1/13),
                .bust: Float(0),
                .blackjack: Float(1/13)
            ],
            .jack : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(4/13),
                .twentyone : Float(1/13),
                .bust: Float(0),
                .blackjack: Float(1/13)
            ],
            .queen : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(4/13),
                .twentyone : Float(1/13),
                .bust: Float(0),
                .blackjack: Float(1/13)
            ],
            .king : [
                .underSeventeen : Float(5/13),
                .seventeen : Float(1/13),
                .eightteen : Float(1/13),
                .nineteen : Float(1/13),
                .twenty : Float(4/13),
                .twentyone : Float(1/13),
                .bust: Float(0),
                .blackjack: Float(1/13)
            ]
        ]
    }
}
