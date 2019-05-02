//
//  File.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation
struct MathHelper {
    static func roundFloat(number: Float) -> Float {
        var save = Double(number)
        save.round()
        return Float(save)
    }
}
enum Status: Int {
    case lost, tie, won, bjwon
    
    func description() -> String {
        switch self {
        case .lost:
            return "You lost."
        case .tie:
            return "Tied."
        case .won:
            return "You won."
        case .bjwon:
            return "You won with a Black Jack"
        }
    }
}

class BlackJackLogic {
    let cards: Deck
    var decks: [Int]
    
    init() {
        cards = Deck()
        decks = Array(repeating: 6, count: 52)
    }
    func newGame() {
        checkDecks()
        
        //print(cardsSplit1[1].description())
    }
    func bankHasAce(bankHand: [Card]) -> Bool {
        for c in bankHand {
            if c.picture == .ace {
                return true
            }
        }
        return false
    }
    func handSplittable(hand: [Card]) -> Bool {
        if hand.count == 2 {
            if hand[0].giveValue() == hand[1].giveValue() {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    func resetDecks() {
        decks.removeAll()
        decks = Array(repeating: 6, count: 52)
    }
    func checkDecks() {
        var cardsLeft = 0
        for c in decks {
            cardsLeft += c
        }
        if cardsLeft <= Int(52*4*0.25) {
            resetDecks()
        }
    }
    func countPoints(hand: [Card]) -> Int {
        var sum = 0
        var aces = 0
        for c in hand {
            if c.picture == .ace {
                aces += 1
            }
            sum += c.giveValue()
        }
        if sum > 21 && aces != 0 {
            if aces == 1 {
                sum -= 10
            }
            else if aces == 2 {
                switch sum {
                case 22..<32: sum -= 10
                default: sum -= 20
                }
            }
            else if aces == 3 {
                switch sum {
                case 22..<32: sum -= 10
                case 32..<42: sum -= 20
                default: sum -= 30
                }
            }
            else if aces >= 4 {
                switch sum {
                case 22..<32: sum -= 10
                case 32..<42: sum -= 20
                case 42..<52: sum -= 30
                default: sum -= 40
                }
            }
        }
        return sum
    }
    func checkBlackJack(hand: [Card]) -> Bool {
        let points = countPoints(hand: hand)
        if hand[0].picture == .ace || hand[1].picture == .ace {
            if (hand[0].giveValue() == 10 || hand[1].giveValue() == 10) && points == 21 {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    func checkTripleSeven(hand: [Card]) -> Bool {
        let points = countPoints(hand: hand)
        if hand[0].picture == .seven && hand[1].picture == .seven && hand[2].picture == .seven && points == 21 {
            return true
        }
        else {
            return false
        }
    }
    func checkBust(cards: [Card]) -> Bool {
        let sum = countPoints(hand: cards)
        if sum > 21 {
            return true
        }
        else {
            return false
        }
    }
    
    func drawCard() -> Card {
        var notThere = true
        var random: Int = 0
        while notThere {
            random = Int(arc4random_uniform(52))
            if decks[random] > 0 {
                decks[random] -= 1
                notThere = false
            }
        }
        return cards.giveCard(random)
    }
    func gameOver(playerCards: [Card],bankCards: [Card], stakes: Float, tookInsurance: Bool,insurance: Float,betOnBust: Bool,bustBet:Float, doubleDown: Bool, split: Bool) -> BlackJackGameOver {
        var bankBJ = false
        var bJ = false
        var ts = false
        var bankBust = false
        var bust = false
        var outcome: Int
        var prize: Float
        var insuranceMoney: Float = 0
        var bustBetMoney: Float = 0
        let bankPoints = countPoints(hand: bankCards)
        let playerPoints = countPoints(hand: playerCards)
        if !split {
            bJ = checkBlackJack(hand: playerCards)
        }
        bankBJ = checkBlackJack(hand: bankCards)
        ts = checkTripleSeven(hand: playerCards)
        bankBust = checkBust(cards: bankCards)
        bust = checkBust(cards: playerCards)
        
        if bankBJ {
            if insurance > 0 {
                insuranceMoney = insurance * 2
            }
            if ts {
                outcome = 3
                prize = stakes * 2.5
            }
            else if bJ {
                outcome = 1
                prize = stakes
            }
            else {
                outcome = 0
                prize = 0
            }
        }
        else {
            if insurance > 0 {
                insuranceMoney = 0
            }
            if bankBust {
                if bustBet > 0 {
                    bustBetMoney = bustBet * 2
                }
                if bust {
                    outcome = 0
                    prize = 0
                }
                else {
                    if bJ {
                        outcome = 3
                        prize = stakes * 2.5
                    }
                    else {
                        outcome = 2
                        prize = stakes * 2
                    }
                }
            }
            else {
                if bustBet > 0 {
                    bustBetMoney = 0
                }
                if bankPoints == playerPoints {
                    if bJ {
                        outcome = 3
                        prize = stakes * 2.5
                    }
                    else {
                        outcome = 1
                        prize = stakes
                    }
                }
                else if bankPoints > playerPoints {
                    outcome = 0
                    prize = 0
                }
                else {
                    outcome = 2
                    prize = stakes * 2
                }
            }
        }
        return BlackJackGameOver(outcome: outcome, prize: prize, stakes: stakes, insurance: insuranceMoney, bust: bustBetMoney, dd: doubleDown, bj: bJ, ts: ts, bbj: bankBJ, bwb: bankBust, ti: tookInsurance, bob: betOnBust, wb: bust, points: playerPoints, bankPoints: bankPoints)
    }
}

struct BlackJackGameOver {
    var winOrLose: Status
    var prizeMoney: Float
    var stakesMoney: Float
    var insurancePayout: Float
    var bustBetPayout: Float
    var doubledDown: Bool
    var hadBlackJack: Bool
    var bankHadBlackJack: Bool
    var hadTripleSeven: Bool
    var bankWentBust: Bool
    var tookInsurance: Bool
    var betOnBust: Bool
    var wentBust: Bool
    var points: Int
    var bankPoints: Int
    
    init(outcome: Int, prize: Float, stakes: Float, insurance: Float, bust: Float, dd: Bool, bj: Bool, ts: Bool, bbj: Bool, bwb: Bool, ti: Bool, bob: Bool, wb: Bool, points: Int, bankPoints: Int) {
        winOrLose = Status.init(rawValue: outcome)!
        prizeMoney = prize
        stakesMoney = stakes
        insurancePayout = insurance
        bustBetPayout = bust
        doubledDown = dd
        hadBlackJack = bj
        hadTripleSeven = ts
        bankHadBlackJack = bbj
        bankWentBust = bwb
        tookInsurance = ti
        betOnBust = bob
        wentBust = wb
        self.points = points
        self.bankPoints = bankPoints
    }
    func description() -> String {
        let answer = """
        Status: \(winOrLose.description())
        Stakes: \(stakesMoney) $
        Prize: \(prizeMoney) $
        Insurance Payout: \(insurancePayout) $
        Bust Bet Payout: \(bustBetPayout) $
        Doubled down: \(doubledDown)
        Had Black Jack: \(hadBlackJack)
        Bank had Black Jack: \(bankHadBlackJack)
        Had Triple Seven: \(hadTripleSeven)
        Bank went Bust: \(bankWentBust)
        Player went Bust: \(wentBust)
        """
        return answer
    }
}


class RouletteLogic {
    let wheel: RouletteWheel
    var winningNumber: RouletteNumber
    init() {
        wheel = RouletteWheel()
        winningNumber = RouletteNumber(0)
    }
    func rienNeVasPlus() {
        winningNumber = self.roll()
    }
    func roll() -> RouletteNumber {
        let randomNumber = Int(arc4random_uniform(37))
        return wheel.whatNumber(random: randomNumber)
    }
    func checkWin(numbers: [Int]) -> Bool {
        for n in numbers {
            if n == winningNumber.number {
                return true
            }
        }
        return false
    }
}

struct RouletteGameOver {
    let outcome: Bool
    let bet: RouletteBet
    let stakes: Float
    let winningNumber: RouletteNumber
    let prize: Float
    init(winning: RouletteNumber,outcome: Bool, bet: RouletteBet, stakes: Float, prize: Float) {
        self.winningNumber = winning
        self.outcome = outcome
        self.bet = bet
        self.stakes = stakes
        self.prize = prize
    }
    func description() -> String {
        let answer = """
        winning number: \(winningNumber.number)
        win: \(outcome)
        stakes: \(stakes) $
        prize: \(prize) $
        """
        return answer
    }
}
