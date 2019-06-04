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
    var dbController: DatabaseController
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
    
    init(player: Player, view: BlackJackController, dbPointer: OpaquePointer?) {
        self.dbController = DatabaseController(pointer: dbPointer)
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
        dbController.updateBalance(player: player)
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
        blackJack[1] = logic.checkBlackJack(hand: cards[1])
        if blackJack[1] {
            view.lPoints1.text! += "\(view.lPoints1.text!)!"
        }
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
    private func setBackOneCard(handIndex: Int) {
        cards[handIndex][index[handIndex]] = Card()
        view.cards?[handIndex][index[handIndex]].isHidden = true
        index[handIndex] -= 1
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
    private func setPointLabelText(handIndex: Int, text: String) {
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
        label.text = text
        label.isHidden = false
    }
    private func setStakesLabel(handIndex: Int) {
        let label: UILabel
        switch handIndex {
        case 1:
            label = view.lStakes
        case 2:
            label = view.lStakes2
        default:
            label = view.lStakes
        }
        label.text = "\(stakes[handIndex]) $"
        label.isHidden = false
    }
    private func hideOrUnhideCardAndStandButtons(handIndex: Int, hidden: Bool) {
        let card: UIButton
        let stand: UIButton
        switch handIndex {
        case 1:
            card = view.bCard1; stand = view.bStand1
        case 2:
            card = view.bCard2; stand = view.bStand2
        default:
            card = view.bCard1; stand = view.bStand1
        }
        card.isHidden = hidden
        stand.isHidden = hidden
    }
    private func hideOrUnhideDoubleDownButton(handIndex: Int, hidden: Bool) {
        let dDown: UIButton
        switch handIndex {
        case 1:
            dDown = view.bDoubleDown1
        case 2:
            dDown = view.bDoubleDown2
        default:
            dDown = view.bDoubleDown1
        }
        dDown.isHidden = hidden
    }
    func splitHand() {
        view.bSplit.isHidden = true
        if cards[1][0].picture == .ace && cards[1][1].picture == .ace {
            twoAceSplit = true
        }
        drawAndUnhideCard(c: cards[1][1], handIndex: 2)
        //cards[2][0] = cards[1][1]
        //index[2] += 1
        setBackOneCard(handIndex: 1)
        //cards[1][1] = Card()
        //index[1] -= 1
        stakes[2] = stakes[1]
        split = true
        countPoints()
        setPointLabel(handIndex: 1)
        setPointLabel(handIndex: 2)
        if twoAceSplit {
            self.performTwoAceSplit()
        }
        else {
            view.unhideSplitButtons()
        }
        
    }
    func performTwoAceSplit() {
        self.card(handIndex: 1)
        self.stand(handIndex: 1)
        self.card(handIndex: 2)
        self.stand(handIndex: 2)
    }
    func doubleDown(handIndex: Int) {
        player.balance -= stakes[handIndex]
        dbController.updateBalance(player: player)
        stakes[handIndex] *= 2
        doubleDown[handIndex] = true
        setStakesLabel(handIndex: handIndex)
        hideOrUnhideCardAndStandButtons(handIndex: handIndex, hidden: true)
        self.card(handIndex: handIndex)
        self.stand(handIndex: handIndex)
        if split || gameIsOver() {
            self.bankDraws()
            self.endGame()
        }
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
        else {
            return false
        }
    }
    func card(handIndex: Int) /*-> String */{
        if !stand[handIndex] {
            drawAndUnhideCard(c: logic.drawCard(), handIndex: handIndex)
            //cards[handIndex][index[handIndex]] = logic.drawCard()
            countPoints()
            setPointLabel(handIndex: handIndex)
            hideOrUnhideDoubleDownButton(handIndex: handIndex, hidden: true)
            if !split {
                blackJack[1] = logic.checkBlackJack(hand: cards[1])
            }
            tripleSeven[handIndex] = logic.checkTripleSeven(hand: cards[handIndex])
            bust[handIndex] = logic.checkBust(cards: cards[handIndex])
            if bust[handIndex] || tripleSeven[handIndex] {
                hideOrUnhideCardAndStandButtons(handIndex: handIndex, hidden: true)
                if tripleSeven[handIndex] {
                    setPointLabelText(handIndex: handIndex, text: "Triple-7")
                }
            }
            if gameIsOver() {
                self.bankDraws()
                self.endGame()
            }
            //index[handIndex] += 1
            //return cards[handIndex][index[handIndex]-1].imageDescription()
        }
        //return "empty"
    }
    func stand(handIndex: Int) {
        stand[handIndex] = true
        hideOrUnhideCardAndStandButtons(handIndex: handIndex, hidden: true)
        hideOrUnhideDoubleDownButton(handIndex: handIndex, hidden: true)
        if gameIsOver(){
            self.bankDraws()
            self.endGame()

        }
    }
    private func endGame() {
        let result1 = self.gameOver(handIndex: 1)
        player.balance += result1.prizeMoney+result1.bustBetPayout+result1.insurancePayout
        dbController.updateBalance(player: player)
        if split {
            let result2 = self.gameOver(handIndex: 2)
            player.balance += result2.prizeMoney+result2.bustBetPayout+result2.insurancePayout
            dbController.updateBalance(player: player)
        }
    }
    func bankDraws() /*-> [String] */ {
        //var images = Array<String>()
        while points[0] < 17 {
            drawAndUnhideCard(c: logic.drawCard(), handIndex: 0)
            //cards[0][index[0]] = logic.drawCard()
            //images.append(cards[0][index[0]].imageDescription())
            points[0] = logic.countPoints(hand: cards[0])
            //index[0] += 1
        }
        
        //return images
    }
    func gameOver(handIndex: Int) -> BlackJackGameOver {
        let result: BlackJackGameOver
        if handIndex == 1 {
            result = logic.gameOver(playerCards: cards[handIndex], bankCards: cards[0], stakes: stakes[handIndex], tookInsurance: tookInsurance, insurance: insuranceMoney, betOnBust: betOnBust, bustBet: bustBetMoney, doubleDown: doubleDown[handIndex], split: split)
        }
        else {
            result = logic.gameOver(playerCards: cards[handIndex], bankCards: cards[0], stakes: stakes[handIndex], tookInsurance: tookInsurance, insurance: insuranceMoney, betOnBust: betOnBust, bustBet: 0, doubleDown: doubleDown[handIndex], split: false)
        }
        dbController.insertBlackJackGameRow(result, player: player)
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
