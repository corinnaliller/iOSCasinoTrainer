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
    let playerChances: [BlackJackPoints:[Int:Float]]
    let bankChances: [BlackJackPoints:[Rank:Float]]
    let furtherChances: [BlackJackPoints:[Int:Float]]
    
    init() {
        self.playerChances = [
            .underSeventeen : [
                4: Float(1),
                5: Float(1),
                6: Float(12/13),
                7: Float(8/13),
                8: Float(7/13),
                9: Float(6/13),
                10: Float(5/13),
                11: Float(5/13),
                12: Float(4/13),
                13: Float(3/13),
                14: Float(2/13),
                15: Float(1/13),
                16: Float(0),
                17: Float(0),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .seventeen : [
                4: Float(0),
                5: Float(0),
                6: Float(1/13),
                7: Float(4/13),
                8: Float(1/13),
                9: Float(1/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(0),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .eightteen : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(1/13),
                8: Float(4/13),
                9: Float(1/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .nineteen : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(1/13),
                9: Float(4/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .twenty : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(1/13),
                10: Float(4/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(1/13),
                20: Float(0),
                21: Float(0)
            ],
            .twentyone : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(0),
                10: Float(1/13),
                11: Float(4/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(1/13),
                20: Float(1/13),
                21: Float(0)
            ],
            .bust : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(0),
                10: Float(0),
                11: Float(0),
                12: Float(4/13),
                13: Float(5/13),
                14: Float(6/13),
                15: Float(7/13),
                16: Float(8/13),
                17: Float(9/13),
                18: Float(10/13),
                19: Float(11/13),
                20: Float(12/13),
                21: Float(1)
            ]
        ]
        self.bankChances = [
            .underSeventeen : [
                .ace: Float(5/13),
                .two: Float(1),
                .three: Float(1),
                .four: Float(1),
                .five: Float(1),
                .six: Float(12/13),
                .seven: Float(8/13),
                .eight: Float(7/13),
                .nine: Float(6/13),
                .ten: Float(5/13),
                .jack: Float(5/13),
                .queen: Float(5/13),
                .king: Float(5/13)
            ],
            .seventeen : [
                .ace: Float(1/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(1/13),
                .seven: Float(4/13),
                .eight: Float(1/13),
                .nine: Float(1/13),
                .ten: Float(1/13),
                .jack: Float(1/13),
                .queen: Float(1/13),
                .king: Float(1/13)
            ],
            .eightteen : [
                .ace: Float(1/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(0),
                .seven: Float(1/13),
                .eight: Float(4/13),
                .nine: Float(1/13),
                .ten: Float(1/13),
                .jack: Float(1/13),
                .queen: Float(1/13),
                .king: Float(1/13)
            ],
            .nineteen : [
                .ace: Float(1/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(0),
                .seven: Float(0),
                .eight: Float(1/13),
                .nine: Float(4/13),
                .ten: Float(1/13),
                .jack: Float(1/13),
                .queen: Float(1/13),
                .king: Float(1/13)
            ],
            .twenty : [
                .ace: Float(1/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(0),
                .seven: Float(0),
                .eight: Float(0),
                .nine: Float(1/13),
                .ten: Float(4/13),
                .jack: Float(4/13),
                .queen: Float(4/13),
                .king: Float(4/13)
            ],
            .twentyone : [
                .ace: Float(4/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(0),
                .seven: Float(0),
                .eight: Float(0),
                .nine: Float(0),
                .ten: Float(1/13),
                .jack: Float(1/13),
                .queen: Float(1/13),
                .king: Float(1/13)
            ],
            .blackjack: [
                .ace: Float(4/13),
                .two: Float(0),
                .three: Float(0),
                .four: Float(0),
                .five: Float(0),
                .six: Float(0),
                .seven: Float(0),
                .eight: Float(0),
                .nine: Float(0),
                .ten: Float(1/13),
                .jack: Float(1/13),
                .queen: Float(1/13),
                .king: Float(1/13)
            ]
        ]
        self.furtherChances = [
            .underSeventeen : [
                4: Float(1),
                5: Float(1),
                6: Float(12/13),
                7: Float(8/13),
                8: Float(7/13),
                9: Float(6/13),
                10: Float(5/13),
                11: Float(5/13),
                12: Float(4/13),
                13: Float(3/13),
                14: Float(2/13),
                15: Float(1/13),
                16: Float(0),
                17: Float(0),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .seventeen : [
                4: Float(0),
                5: Float(0),
                6: Float(1/13),
                7: Float(4/13),
                8: Float(1/13),
                9: Float(1/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(0),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .eightteen: [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(1/13),
                8: Float(4/13),
                9: Float(1/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(0),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .nineteen : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(1/13),
                9: Float(4/13),
                10: Float(1/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(0),
                20: Float(0),
                21: Float(0)
            ],
            .twenty : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(1/13),
                10: Float(4/13),
                11: Float(1/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(1/13),
                20: Float(0),
                21: Float(0)
            ],
            .twentyone : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(0),
                10: Float(1/13),
                11: Float(4/13),
                12: Float(1/13),
                13: Float(1/13),
                14: Float(1/13),
                15: Float(1/13),
                16: Float(1/13),
                17: Float(1/13),
                18: Float(1/13),
                19: Float(1/13),
                20: Float(1/13),
                21: Float(0)
            ],
            .bust : [
                4: Float(0),
                5: Float(0),
                6: Float(0),
                7: Float(0),
                8: Float(0),
                9: Float(0),
                10: Float(0),
                11: Float(0),
                12: Float(4/13),
                13: Float(5/13),
                14: Float(6/13),
                15: Float(7/13),
                16: Float(8/13),
                17: Float(9/13),
                18: Float(10/13),
                19: Float(11/13),
                20: Float(12/13),
                21: Float(1)
            ]
        ]
    }
}
