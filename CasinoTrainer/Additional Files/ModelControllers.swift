//
//  File.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 21.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation

class BlackJackLogicController {
    let db: SQLiteDatabase?
    let player: Player
    let view: BlackJackController
    let logic: BlackJackLogic
    var stakes: [Float]
    var insuranceMoney: Float
    var bustBetMoney: Float
    var cards: [[Card]]
    var index: [Int]
    var points: [Int]
    var split: Bool
    var gameOver: Bool
    var bust: [Bool]
    var stand: [Bool]
    var doubleDown: [Bool]
    var blackJack: [Bool]
    var tripleSeven: [Bool]
    var bankHasAce: Bool
    var handSplittable: Bool
    var twoAceSplit: Bool
    var betOnBust: Bool
    var tookInsurance: Bool
    
    init(player: Player, view: BlackJackController) {
        db = try! SQLiteDatabase.open(path: Database.CasinoTrainer.rawValue)
        if db == nil {
            print("Could not open database.")
        }
        self.player = player
        self.view = view
        logic = BlackJackLogic()
        stakes = [0,0,0]
        insuranceMoney = 0
        bustBetMoney = 0
        cards = Array(repeating: Array(repeating: Card(), count: 6), count: 3)
        index = [0,0,0]
        points = [0,0,0]
        split = false
        gameOver = false
        bust = [false, false, false]
        stand = [false, false, false]
        doubleDown = [false, false, false]
        blackJack = [false, false, false]
        tripleSeven = [false,false,false]
        bankHasAce = false
        handSplittable = false
        twoAceSplit = false
        tookInsurance = false
        betOnBust = false
    }
    private func reset() {
        logic.checkDecks()
        stakes = [0,0,0]
        insuranceMoney = 0
        bustBetMoney = 0
        cards = Array(repeating: Array(repeating: Card(), count: 6), count: 3)
        index = [0,0,0]
        points = [0,0,0]
        split = false
        gameOver = false
        bust = [false, false, false]
        stand = [false, false, false]
        doubleDown = [false, false, false]
        blackJack = [false, false, false]
        tripleSeven = [false,false,false]
        bankHasAce = false
        handSplittable = false
        twoAceSplit = false
        tookInsurance = false
        betOnBust = false
        
    }
    func startNewGame(newStakes: Float, newBustBet: Float) -> [String] {
        reset()
        stakes[1] = newStakes
        bustBetMoney = newBustBet
        if (bustBetMoney > 0) {
            betOnBust = true
        }
        cards[0][index[0]] = logic.drawCard()
        index[0] += 1
        cards[1][index[1]] = logic.drawCard()
        index[1] += 1
        cards[1][index[1]] = logic.drawCard()
        index[1] += 1
        bankHasAce = logic.bankHasAce(bankHand: cards[0])
        blackJack[1] = logic.checkBlackJack(hand: cards[1])
        handSplittable = logic.handSplittable(hand: [cards[1][0],cards[1][1]])
        countPoints()
        return [cards[0][0].imageDescription(),cards[1][0].imageDescription(),cards[1][1].imageDescription()]
    }
    private func countPoints() {
        points[0] = logic.countPoints(hand: cards[0])
        points[1] = logic.countPoints(hand: cards[1])
        points[2] = logic.countPoints(hand: cards[2])
    }
    func splitHand() {
        if cards[1][0].picture == .ace && cards[1][1].picture == .ace {
            twoAceSplit = true
        }
        cards[2][0] = cards[1][1]
        index[2] += 1
        cards[1][1] = Card()
        index[1] -= 1
        stakes[2] = stakes[1]
        split = true
        countPoints()
    }
    func doubleDown(i: Int) {
        stakes[i] *= 2
        doubleDown[i] = true
    }
    func buyInsurance(money: Float) {
        insuranceMoney = money
        tookInsurance = true
    }
    func gameIsOver() -> Bool {
        if stand[1] || bust[1] || tripleSeven[1] {
            if split {
                if stand[2] || bust[2] || tripleSeven[2] {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return true
            }
        }
        return false
    }
    func card(i: Int) -> String {
        if !stand[i] {
            cards[i][index[i]] = logic.drawCard()
            countPoints()
            if !split {
                blackJack[1] = logic.checkBlackJack(hand: cards[1])
            }
            tripleSeven[i] = logic.checkTripleSeven(hand: cards[i])
            bust[i] = logic.checkBust(cards: cards[i])
            index[i] += 1
            return cards[i][index[i]-1].imageDescription()
        }
        return "empty"
    }
    func stand(i: Int) {
        stand[i] = true
    }
    func bankDraws() -> [String] {
        var images = Array<String>()
        while points[0] < 17 {
            cards[0][index[0]] = logic.drawCard()
            images.append(cards[0][index[0]].imageDescription())
            points[0] = logic.countPoints(hand: cards[0])
            index[0] += 1
        }
        return images
    }
    func gameOver(i: Int) -> BlackJackGameOver {
        let result: BlackJackGameOver
        if i == 1 {
            result = logic.gameOver(playerCards: cards[i], bankCards: cards[0], stakes: stakes[i], tookInsurance: tookInsurance, insurance: insuranceMoney, betOnBust: betOnBust, bustBet: bustBetMoney, doubleDown: doubleDown[i], split: split)
        }
        else {
            result = logic.gameOver(playerCards: cards[i], bankCards: cards[0], stakes: stakes[i], tookInsurance: tookInsurance, insurance: insuranceMoney, betOnBust: betOnBust, bustBet: 0, doubleDown: doubleDown[i], split: false)
        }
        try? db?.insertBlackJackGameRow(result, player: player)
        return result
    }
}
class RouletteLogicController {
    let logic: RouletteLogic
    var bet: RouletteBet?
    var stakes: Float?
    init() {
        logic = RouletteLogic()
    }
    func rienNeVasPlus(bet: RouletteBet,stakes: Float) -> RouletteGameOver {
        self.bet = bet
        self.stakes = stakes
        logic.rienNeVasPlus()
        let win = logic.checkWin(numbers: bet.numbers)
        let prizeMoney: Float
        if win {
            prizeMoney = stakes * Float(bet.payout)
        }
        else {
            prizeMoney = -stakes
        }
        return RouletteGameOver(winning:logic.winningNumber,outcome: win, bet: bet, stakes: stakes,prize: prizeMoney)
    }
}
