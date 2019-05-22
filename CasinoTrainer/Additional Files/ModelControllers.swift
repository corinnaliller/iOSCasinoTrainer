//
//  File.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 21.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation
import UIKit

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
        view.setForNewGame()
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
        view.setForNewGame()
    }
    func startNewGame() {
        reset()
        view.switchBustBet.isHidden = true
        stakes[1] = view.stakesMoney
        bustBetMoney = view.bustBetMoney
        player.balance -= (stakes[1]+bustBetMoney)
        try? db?.updateBalance(player: player)
        if (bustBetMoney > 0) {
            betOnBust = true
            view.lBustBet.isHidden = true
        }
        drawAndUnhideCard(c: logic.drawCard(), handIndex: 0)
        drawAndUnhideCard(c: logic.drawCard(), handIndex: 1)
        drawAndUnhideCard(c: logic.drawCard(), handIndex: 1)
        countPoints()
        setPointLabel(handIndex: 0)
        setPointLabel(handIndex: 1)
//        cards[0][index[0]] = logic.drawCard()
//        view.cards?[0][index[0]].image = UIImage(named: cards[0][index[0]].imageDescription())
//        view.cards?[0][index[0]].isHidden = false
//        index[0] += 1
//        cards[1][index[1]] = logic.drawCard()
//        index[1] += 1
//        cards[1][index[1]] = logic.drawCard()
//        index[1] += 1
        view.unhideButtonsForGame()
        if logic.bankHasAce(bankHand: cards[0]) {
            bankHasAce = true
            view.bPlay.setTitle("buy insurance", for: .normal)
            view.slStakes.maximumValue = player.balance
            view.slStakes.minimumValue = 0
            view.slStakes.value = 0
        }
        else {
            view.slStakes.isHidden = true
            view.bPlay.isHidden = true
        }
        if logic.checkBlackJack(hand: cards[1]) {
            blackJack[1] = true
        }
        if logic.handSplittable(hand: [cards[1][0],cards[1][1]]) {
            view.bSplit.isHidden = false
        }
        
        //return [cards[0][0].imageDescription(),cards[1][0].imageDescription(),cards[1][1].imageDescription()]
    }
    private func drawAndUnhideCard(c: Card, handIndex: Int) {
        cards[handIndex][index[handIndex]] = c
        view.cards?[handIndex][index[handIndex]].image = UIImage(named: c.imageDescription())
        view.cards?[handIndex][index[handIndex]].isHidden = false
        index[handIndex] += 1
    }
    private func countPoints() {
        points[0] = logic.countPoints(hand: cards[0])
        points[1] = logic.countPoints(hand: cards[1])
        points[2] = logic.countPoints(hand: cards[2])
    }
    private func setPointLabel(handIndex: Int) {
        let label: UILabel
        switch handIndex {
        case 0:
            label = view.lPointsBank
        case 1:
            label = view.lPoints1
        case 2:
            label = view.lPoints2
        default:
            label = view.lPointsBank
        }
        label.text = "\(points[handIndex])"
        label.isHidden = false
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
    let view: RouletteController
    let player: Player
    let db: SQLiteDatabase?
    var bet: RouletteBet?
    var stakes: Float?
    init(player: Player, view: RouletteController) {
        db = try! SQLiteDatabase.open(path: Database.CasinoTrainer.rawValue)
        if db == nil {
            print("Could not open database.")
        }
        logic = RouletteLogic()
        self.player = player
        self.view = view
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
        let outcome = RouletteGameOver(winning:logic.winningNumber,outcome: win, bet: bet, stakes: stakes,prize: prizeMoney)
        try? db?.insertRouletteGameRow(outcome, player: player)
        return outcome
    }
}
