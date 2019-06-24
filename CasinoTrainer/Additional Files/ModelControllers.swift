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
        setForNewGame()
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
    func startNewGame() {
        setForNewGame()
        view.switchBustBet.isHidden = true
        stakes[1] = MathHelper.roundFloat(number: view.slStakes.value)
        recalculateAndUpdateBalance(money: stakes[1], addition: false)
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
        unhideButtonsForGame()
        if logic.bankHasAce(bankHand: cards[0]) {
            bankHasAce = true
            view.bPlay.setTitle("buy insurance", for: .normal)
            view.bPlay.isHidden = false
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
    func prepareForNewGame() {
        setForNewGame()
        view.bPlay.setTitle("play", for: .normal)
        resetSlider()
        resetBustSwitch()
    }
    
    private func setForNewGame() {
        hideAllCards()
        hideButtons()
        hideLabelsAtStart()
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
        recalculateAndUpdateBalance(money: stakes[2], addition: false)
        split = true
        countPoints()
        setPointLabel(handIndex: 1)
        setPointLabel(handIndex: 2)
        if twoAceSplit {
            self.performTwoAceSplit()
        }
        else {
            unhideSplitButtons()
        }
        
    }
    func performTwoAceSplit() {
        self.card(handIndex: 1)
        self.stand(handIndex: 1)
        self.card(handIndex: 2)
        self.stand(handIndex: 2)
    }
    func doubleDown(handIndex: Int) {
        recalculateAndUpdateBalance(money: stakes[handIndex], addition: false)
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
        recalculateAndUpdateBalance(money: insuranceMoney, addition: false)
        view.bPlay.isHidden = true
    }
    func setBustBet() {
        view.switchBustBet.isHidden = true
        bustBetMoney = MathHelper.roundFloat(number: view.slStakes.value)
        recalculateAndUpdateBalance(money: bustBetMoney, addition: false)
        view.bPlay.setTitle("play", for: .normal)
    }
    private func recalculateAndUpdateBalance(money: Float, addition: Bool) {
        if addition {
            player.balance += money
        }
        else {
            player.balance -= money
        }
        dbController.updateBalance(player: player)
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
        let allMoney = result1.prizeMoney+result1.bustBetPayout+result1.insurancePayout
        recalculateAndUpdateBalance(money: allMoney, addition: true)
        if split {
            let result2 = self.gameOver(handIndex: 2)
            let allMoney2 = result2.prizeMoney+result2.bustBetPayout+result2.insurancePayout
            recalculateAndUpdateBalance(money: allMoney2, addition: true)
        }
        view.bPlay.setTitle("new game", for: .normal)
        view.bPlay.isHidden = false
        hideButtons()
        reset()
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
        setPointLabel(handIndex: 0)
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
    private func hideAllCards() {
        for arrays in view.cards! {
            for image in arrays {
                image.isHidden = true
            }
        }
    }
    private func hideButtons() {
        view.bSplit.isHidden = true
        view.bCard1.isHidden = true
        view.bCard2.isHidden = true
        view.bStand1.isHidden = true
        view.bStand2.isHidden = true
        view.bDoubleDown1.isHidden = true
        view.bDoubleDown2.isHidden = true
    }
    private func hideLabelsAtStart() {
        view.lStakes2.isHidden = true
        view.lPoints1.isHidden = true
        view.lPoints2.isHidden = true
        view.lPointsBank.isHidden = true
        view.lBustBet.isHidden = true
        view.lInsurance.isHidden = true
    }
    private func resetSlider() {
        view.slStakes.minimumValue = 1
        view.slStakes.maximumValue = player.balance
        view.slStakes.value = 1
        view.slStakes.isHidden = false
        view.lStakes.text = "\(MathHelper.roundFloat(number: view.slStakes.value)) $"
        view.lBalance.text = "\(MathHelper.roundFloat(number: player.balance)) $"
    }
    private func resetBustSwitch() {
        view.switchBustBet.isOn = false
        view.switchBustBet.isHidden = false
    }
    func unhideButtonsForGame() {
        view.bCard1.isHidden = false
        view.bStand1.isHidden = false
        view.bDoubleDown1.isHidden = false
    }
    func unhideSplitButtons() {
        view.bCard2.isHidden = false
        view.bStand2.isHidden = false
        view.bDoubleDown2.isHidden = false
    }
}
class RouletteLogicController {
    let logic: RouletteLogic
    let view: RouletteController
    let player: Player
    let dbController: DatabaseController
    var bet: RouletteBet?
    var stakes: Float?
    init(player: Player, view: RouletteController, db: OpaquePointer?) {
        self.dbController = DatabaseController(pointer: db)
        self.logic = RouletteLogic()
        self.player = player
        self.view = view
    }
    func rienNeVasPlus(bet: RouletteBet,stakes: Float) /*-> RouletteGameOver */ {
        view.bSelectBet.isHidden = true
        view.slStakes.isHidden = true
        self.bet = bet
        self.stakes = stakes
        player.balance -= self.stakes!
        dbController.updateBalance(player: player)
        view.lBalance.text = "Balance: \(MathHelper.roundFloat(number: player.balance)) $"
        logic.rienNeVasPlus()
        endGame()
        
    }
    private func endGame() {
        if logic.winningNumber.color == RouletteColor.black {
            view.lResult.textColor = UIColor.black
        }
        else if logic.winningNumber.color == RouletteColor.red {
            view.lResult.textColor = UIColor.red
        }
        else {
            view.lResult.textColor = UIColor.green
        }
        
        view.lResult.isHidden = false
        //guest!.endRoulette(outcome: result)
        
        view.lWin.isHidden = false
        view.lBalance.text = "Balance: \(MathHelper.roundFloat(number: player.balance)) $"
        let win = logic.checkWin(numbers: bet!.numbers)
        let prizeMoney: Float
        if win {
            prizeMoney = self.stakes! * Float(bet!.payout)
        }
        else {
            prizeMoney = -self.stakes!
        }
        let outcome = RouletteGameOver(winning:logic.winningNumber,outcome: win, bet: bet!, stakes: stakes!,prize: prizeMoney)
        dbController.insertRouletteGameRow(outcome, player: player)
        player.balance += outcome.prize
        dbController.updateBalance(player: player)
        view.lResult.text = "\(outcome.winningNumber.number)"
        if outcome.outcome {
            view.lWin.text = "\(outcome.prize) $"
        }
        else {
            view.lWin.text = "You lost"
        }
    }
    func noBetSelected() {
        view.bRienNeVasPlus.isHidden = true
        view.lBet.text = "No bet selected"
        view.slStakes.isHidden = true
        view.lStakes.isHidden = true
        view.bSelectBet.isHidden=false
    }
    func didSelectBet(bet: RouletteBet) {
        view.bSelectBet.isHidden=true
        if bet is OutsideBet {
            let out = bet as! OutsideBet
            print(out.description())
        }
        else if bet is InsideBet {
            let ins = bet as! InsideBet
            print(ins.description())
        }
        view.bRienNeVasPlus.isHidden = false
        view.slStakes.value = Float(view.minimum)
        view.slStakes.minimumValue = Float(view.minimum)
        if player.balance < (Float((1200 * view.minimum) / (bet.payout - 1))) {
            view.slStakes.maximumValue = player.balance
        }
        else {
            view.slStakes.maximumValue = Float((1200 * view.minimum) / (bet.payout - 1))
        }
        view.lBalance.text = "Balance: \(MathHelper.roundFloat(number: player.balance-view.slStakes.value)) $"
        view.slStakes.isHidden = false
        view.lStakes.text = "\(MathHelper.roundFloat(number:view.slStakes.value)) $"
        view.lStakes.isHidden = false
        if bet is InsideBet {
            let b = bet as! InsideBet
            view.lBet.text = "\(b.description())"
        }
        else if bet is OutsideBet {
            let b = bet as! OutsideBet
            view.lBet.text = "\(b.description())"
        }
        else {
            view.lBet.text = "Something went wrong!"
        }
    }
    func playAgain() {
        view.bet = nil
        
        view.bSelectBet.isHidden = false
        view.lResult.isHidden = true
        view.lWin.isHidden = true
        view.lBet.text = "No bet selected"
    }
    func selectStakes() {
        view.lStakes.text = "\(MathHelper.roundFloat(number: view.slStakes.value)) $"
        view.lBalance.text = "Balance: \(MathHelper.roundFloat(number:player.balance-view.slStakes.value)) $"
    }
}

class SelectRouletteBetController {
    let view: RouletteBetViewController
    var bet: RouletteBet?
    var selectedNumber: Int
    var splitNumber: Int
    
    init(view: RouletteBetViewController) {
        self.view = view
        self.selectedNumber = 37
        self.splitNumber = 0
        hideFullNumberButtons()
        hideColumnButtons()
        hideDozenButtons()
        hideSplitButtons()
    }
    func selectFullNumber(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        view.lMessage.text = "\(selectedNumber)"
    }
    func selectSplitNumber(sender: UIButton) {
        resetButtons(collection: "full")
        hideSplitButtons()
        view.bSetBet.isHidden = true
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        view.lMessage.text = "Split \(selectedNumber)"
        unhideSplitButtons(number: selectedNumber)
    }
    func selectCorner(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        view.lMessage.text = "Corner \(selectedNumber): \(selectedNumber), \(selectedNumber+1), \(selectedNumber+3), \(selectedNumber+4)"
    }
    func selectSixLine(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        view.lMessage.text = "Six Line \(selectedNumber)"
    }
    func selectStreet(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        view.lMessage.text = "Street \(selectedNumber)"
    }
    func selectSplit(tag: Int) {
        splitNumber = tag
        view.bSetBet.isHidden = false
        hideSplitButtons()
    }
    func selectColumnBet(_ sender: UIButton) {
        resetButtons(collection: "column")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        let count: String
        switch sender.tag {
        case 1:
            count = "1st"
        case 2:
            count = "2nd"
        case 3:
            count = "3rd"
        default:
            count = "\(sender.tag)th"
        }
        view.lMessage.text = "\(count) Column"
    }
    func selectDozenBet(_ sender: UIButton) {
        resetButtons(collection: "dozen")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        let count: String
        switch sender.tag {
        case 1:
            count = "1st"
        case 2:
            count = "2nd"
        case 3:
            count = "3rd"
        default:
            count = "\(sender.tag)th"
        }
        view.lMessage.text = "\(count) Dozen"
    }
    func selectOutsideBet(_ sender: UIButton) {
        resetButtons(collection: "outside")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        let out: String
        switch sender.tag {
        case 1:
            out = "Low"
        case 2:
            out = "Even"
        case 3:
            out = "Red"
        case 4:
            out = "Black"
        case 5:
            out = "Odd"
        case 6:
            out = "High"
        default:
            return
        }
        view.lMessage.text = "\(out) Numbers"
    }
    func selectFullNumber(_ sender: UIButton) {
        switch view.betTypes.selectedSegmentIndex {
        case 1:
            selectFullNumber(sender: sender)
        case 4:
            selectCorner(sender: sender)
        case 5:
            selectSplitNumber(sender: sender)
        case 6:
            selectSixLine(sender: sender)
        case 7:
            selectStreet(sender:sender)
        default:
            return
        }
    }
    func selectBetType(_ sender: UISegmentedControl) {
        selectedNumber = 37
        splitNumber = 0
        view.lMessage.text = ""
        switch sender.selectedSegmentIndex {
        case 0:
            resetButtons(collection: "outside"); unhideOutsideButtons();hideDozenButtons();hideColumnButtons();hideFullNumberButtons();hideSplitButtons()
        case 1:
            resetButtons(collection: "full");hideOutsideButtons();hideDozenButtons();hideColumnButtons();unhideFullNumberButtons();hideSplitButtons()
        case 2:
            resetButtons(collection: "dozen");hideOutsideButtons();unhideDozenButtons();hideColumnButtons();hideFullNumberButtons();hideSplitButtons()
        case 3:
            resetButtons(collection: "column");hideOutsideButtons();hideDozenButtons();unhideColumnButtons();hideFullNumberButtons();hideSplitButtons()
        case 4:
            resetButtons(collection: "full");hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideForCorner();hideSplitButtons()
        case 5:
            resetButtons(collection: "full");hideOutsideButtons();hideDozenButtons();hideColumnButtons();unhideFullNumberButtons()
        case 6:
            resetButtons(collection: "full");hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideForSixLine();hideSplitButtons()
        case 7:
            resetButtons(collection: "full");hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideForStreet();hideSplitButtons()
        case 8: hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideFullNumberButtons();view.lMessage.text="First Three";hideSplitButtons();selectedNumber = 0
        case 9:
            hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideFullNumberButtons();view.lMessage.text="First Four";hideSplitButtons();selectedNumber = 0
        default:
            return
        }
    }
    func placeRouletteBet() -> Bool {
        if selectedNumber != 37 {
            if view.betTypes.selectedSegmentIndex == 0 {
                let type: Outside
                switch selectedNumber {
                case 1: type = Outside.low
                case 2: type = Outside.even
                case 3: type = Outside.red
                case 4: type = Outside.black
                case 5: type = Outside.odd
                case 6: type = Outside.high
                default: return false
                }
                bet = OutsideBet(type: type)
            }
            else {
                let type: Inside
                switch view.betTypes.selectedSegmentIndex {
                case 1: type = Inside.straightUp
                case 2: type = Inside.dozen
                case 3: type = Inside.column
                case 4: type = Inside.corner
                case 5: type = Inside.split
                case 6: type = Inside.sixLine
                case 7: type = Inside.street
                case 8: type = Inside.firstThree
                case 9: type = Inside.firstFour
                default: return false
                }
                bet = InsideBet(type: type, number: selectedNumber, def: splitNumber)
            }
            return true
        }
        else {
            return false
        }
    }
    
    func hideForCorner() {
        for b in view.fullNumberButtons {
            if (b.tag % 3) == 0 || b.tag == 34 || b.tag == 35 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideForStreet() {
        for b in view.fullNumberButtons {
            if (b.tag % 3) == 0 || (b.tag % 3) == 2 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideForSixLine() {
        for b in view.fullNumberButtons {
            if (b.tag % 3) == 0 || (b.tag % 3) == 2 || b.tag == 34 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideFullNumberButtons() {
        for b in view.fullNumberButtons {
            b.isHidden = true
        }
    }
    func hideOutsideButtons() {
        for b in view.outsideButtons {
            b.isHidden = true
        }
    }
    func hideColumnButtons() {
        for b in view.columnButtons {
            b.isHidden = true
        }
    }
    func hideDozenButtons() {
        for b in view.dozenButtons {
            b.isHidden = true
        }
    }
    func hideSplitButtons() {
        view.split1.isHidden = true
        view.split2.isHidden = true
    }
    func unhideFullNumberButtons() {
        for b in view.fullNumberButtons {
            b.isHidden = false
        }
    }
    func unhideOutsideButtons() {
        for b in view.outsideButtons {
            b.isHidden = false
        }
    }
    func unhideColumnButtons() {
        for b in view.columnButtons {
            b.isHidden = false
        }
    }
    func unhideDozenButtons() {
        for b in view.dozenButtons {
            b.isHidden = false
        }
    }
    func unhideSplitButtons(number: Int) {
        if (number % 3) == 0 {
            if number == 36 {
                view.lMessage.text = "No split possible"
            }
            else {
                view.split2.isHidden = false
            }
        }
        else if number == 34 || number == 35 {
            view.split1.isHidden = false
        }
        else {
            view.split1.isHidden = false
            view.split2.isHidden = false
        }
        
    }
    func resetButtons(collection: String) {
        let coll: [UIButton]
        switch collection {
        case "full":
            coll = view.fullNumberButtons
        case "column":
            coll = view.columnButtons
        case "dozen":
            coll = view.dozenButtons
        case "outside":
            coll = view.outsideButtons
        default:
            return
        }
        
        for b in coll {
            b.backgroundColor = UIColor.lightGray
            b.alpha = 0.6
            b.setImage(nil, for: .normal)
        }
    }
}
