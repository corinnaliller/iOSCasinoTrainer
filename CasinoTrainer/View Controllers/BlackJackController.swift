//
//  BlackJackController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class BlackJackController: UIViewController {
    @IBOutlet weak var iBank1: UIImageView!
    @IBOutlet weak var iBank2: UIImageView!
    @IBOutlet weak var iBank3: UIImageView!
    @IBOutlet weak var iBank4: UIImageView!
    @IBOutlet weak var iBank5: UIImageView!
    @IBOutlet weak var iBank6: UIImageView!
    @IBOutlet weak var iSplit11: UIImageView!
    @IBOutlet weak var iSplit12: UIImageView!
    @IBOutlet weak var iSplit13: UIImageView!
    @IBOutlet weak var iSplit14: UIImageView!
    @IBOutlet weak var iSplit15: UIImageView!
    @IBOutlet weak var iSplit16: UIImageView!
    @IBOutlet weak var iSplit21: UIImageView!
    @IBOutlet weak var iSplit22: UIImageView!
    @IBOutlet weak var iSplit23: UIImageView!
    @IBOutlet weak var iSplit24: UIImageView!
    @IBOutlet weak var iSplit25: UIImageView!
    @IBOutlet weak var iSplit26: UIImageView!
    @IBOutlet weak var bPlay: UIButton!
    @IBOutlet weak var bCard1: UIButton!
    @IBOutlet weak var bCard2: UIButton!
    @IBOutlet weak var bStand1: UIButton!
    @IBOutlet weak var bStand2: UIButton!
    @IBOutlet weak var bSplit: UIButton!
    @IBOutlet weak var bDoubleDown1: UIButton!
    @IBOutlet weak var bDoubleDown2: UIButton!
    
    @IBOutlet weak var slStakes: UISlider!
    @IBOutlet weak var lStakes: UILabel!
    @IBOutlet weak var lStakes2: UILabel!
    @IBOutlet weak var lPoints1: UILabel!
    @IBOutlet weak var lPoints2: UILabel!
    @IBOutlet weak var lPointsBank: UILabel!
    @IBOutlet weak var lBustBet: UILabel!
    @IBOutlet weak var lInsurance: UILabel!
    
    @IBOutlet weak var lBalance: UILabel!
    @IBOutlet weak var switchBustBet: UISwitch!
    
    var dbPointer: OpaquePointer?
    
    var cards: [[UIImageView]]?
    var pointLabels: [UILabel]?
    var guest: Player?
    var game: BlackJackLogicController?
    var index = [0,0,0]
    var bustBetMoney: Float = 0
    var stakesMoney: Float = 0
    var insuranceMoney: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //print(guest?.playerName)
        //print(guest?.balance)
        cards = [[iBank1,iBank2,iBank3,iBank4,iBank5,iBank6],[iSplit11,iSplit12,iSplit13,iSplit14,iSplit15,iSplit16],[iSplit21,iSplit22,iSplit23,iSplit24,iSplit25,iSplit26]]
        pointLabels = [lPointsBank,lPoints1,lPoints2]
        //setForNewGame()
        game = BlackJackLogicController(player: guest!, view: self, dbPointer: dbPointer)
    }
//    func setForNewGame() {
//        hideAllCards()
//        hideButtons()
//        hideLabelsAtStart()
//        index = [0,0,0]
//    }
//    func hideAllCards() {
//        for arrays in cards! {
//            for image in arrays {
//                image.isHidden = true
//            }
//        }
//    }
//    func hideLabelsAtStart() {
//        lStakes2.isHidden = true
//        for label in pointLabels! {
//            label.isHidden = true
//        }
//        lBustBet.isHidden = false
//        lInsurance.isHidden = true
//    }
//    func hideButtons() {
//        bSplit.isHidden = true
//        bCard1.isHidden = true
//        bCard2.isHidden = true
//        bStand1.isHidden = true
//        bStand2.isHidden = true
//        bDoubleDown1.isHidden = true
//        bDoubleDown2.isHidden = true
//    }
//    func unhideButtonsForGame() {
//        bCard1.isHidden = false
//        bStand1.isHidden = false
//        bDoubleDown1.isHidden = false
//    }
//    func unhideSplitButtons() {
//        bCard2.isHidden = false
//        bStand2.isHidden = false
//        bDoubleDown2.isHidden = false
//    }
    @IBAction func setStakes(_ sender: UISlider) {
        if bPlay.title(for: .normal) == "play" {
            //stakesMoney = MathHelper.roundFloat(number: slStakes.value)
            lStakes.text = "\(MathHelper.roundFloat(number: slStakes.value)) $"
            lBalance.text = "\(MathHelper.roundFloat(number:guest?.balance ?? 100.0) - stakesMoney - bustBetMoney) $"
        }
        else if bPlay.title(for: .normal) == "bet on bust" {
            //bustBetMoney = MathHelper.roundFloat(number: slStakes.value)
            lBustBet.isHidden = false
            lBustBet.text = "\(MathHelper.roundFloat(number: slStakes.value)) $"
            lBalance.text = "\(MathHelper.roundFloat(number:guest?.balance ?? 100.0) - stakesMoney - bustBetMoney) $"
        }
        else if bPlay.title(for: .normal) == "buy insurance" {
            //insuranceMoney = MathHelper.roundFloat(number: slStakes.value)
            lInsurance.text = "\(MathHelper.roundFloat(number: slStakes.value)) $"
            lInsurance.isHidden = false
            lBalance.text = "\(MathHelper.roundFloat(number:guest?.balance ?? 100.0) - insuranceMoney) $"
        }
    }
    @IBAction func start(_ sender: UIButton) {
        switch (sender.title(for: .normal)) {
        case "play":
            game!.startNewGame()
        case "new game":
            game!.prepareForNewGame()
        case "bet on bust":
           game!.setBustBet()
        case "buy insurance":
            game!.buyInsurance(money: MathHelper.roundFloat(number: slStakes.value))
        default:
            return
        }
    }
    @IBAction func setBustBet(_ sender: UISwitch) {
        if sender.isOn {
            bPlay.setTitle("bet on bust", for: .normal)
            slStakes.maximumValue = guest?.balance ?? 100.0 - stakesMoney
            slStakes.minimumValue = 0
            slStakes.value = 0
        }
        else {
            bPlay.setTitle("play", for: .normal)
            lBustBet.text = "Bust Bet"
            slStakes.maximumValue = guest?.balance ?? 100.0
            bustBetMoney = 0.0
        }
    }
//    func buyInsurance() {
//        game!.buyInsurance(money: insuranceMoney)
//        //guest?.balance -= insuranceMoney
//        //bPlay.isHidden = true
//    }
//    func betOnBust() {
//        switchBustBet.isHidden = true
//        bPlay.setTitle("play", for: .normal)
//    }
//    func startNewGame() {
//        game!.startNewGame()
    
        //switchBustBet.isHidden = true
//        if bustBetMoney == 0.0 {
//            lBustBet.isHidden = true
//        }
        //let images = game!.startNewGame(newStakes: stakesMoney, newBustBet: bustBetMoney)
        //guest?.balance -= (stakesMoney+bustBetMoney)
        //cards?[0][0].image = UIImage(named: images[0])
//        cards?[0][0].isHidden = false
//        index[0] += 1
        //print(index[0])
//        cards?[1][index[1]].image = UIImage(named: images[1])
//        cards?[1][index[1]].isHidden = false
//        index[1] += 1
        //print(index[1])
//        cards?[1][index[1]].image = UIImage(named: images[2])
//        cards?[1][index[1]].isHidden = false
//        index[1] += 1
        //print(index[1])
//        lPointsBank.text = "\(game!.points[0])"
//        lPointsBank.isHidden = false
//        lPoints1.text = "\(game!.points[1])"
//        lPoints1.isHidden = false
//        if game!.handSplittable {
//            bSplit.isHidden = false
//        }
//        unhideButtonsForGame()
//        if game!.bankHasAce {
//            bPlay.setTitle("buy insurance", for: .normal)
//            slStakes.maximumValue = guest?.balance ?? 100.0-(bustBetMoney+stakesMoney)
//            slStakes.minimumValue = 0
//            slStakes.value = 0
//        }
//        else {
//            slStakes.isHidden = true
//            bPlay.isHidden = true
//        }
        
//    }
//    func prepareForNewGame() {
//        bPlay.setTitle("play", for: .normal)
//        setForNewGame()
//        switchBustBet.isOn = false
//        switchBustBet.isHidden = false
//        slStakes.minimumValue = 1
//        slStakes.maximumValue = guest?.balance ?? 100.0
//        slStakes.value = 1
//        slStakes.isHidden = false
//        lStakes.text = "\(MathHelper.roundFloat(number: slStakes.value)) $"
//        lBalance.text = "\(MathHelper.roundFloat(number: guest?.balance ?? 100)) $"
//    }
//    func bankDraws() {
        //let imageNames =
//        game!.bankDraws()
        //print(imageNames)
//        for pic in imageNames {
//            cards?[0][index[0]].image = UIImage(named: pic)
//            cards?[0][index[0]].isHidden = false
//            index[0] += 1
//        }
//        pointLabels?[0].text = "\(game!.points[0])"
//        self.gameOver()
//    }
//    func gameOver() {
//        bPlay.setTitle("new game", for: .normal)
//        bPlay.isHidden = false
//        hideButtons()
//        let go = game!.gameOver(handIndex: 1)
        //print(go.prizeMoney)
//        print(go.description())
        //guest!.endBlackJack(outcome: go)
        //print(guest?.balance)
//        if game!.split {
//            let go2 = game!.gameOver(handIndex: 2)
            //guest!.endBlackJack(outcome: go2)
//            print(go2.description())
            //print(go2.prizeMoney)
            //print(guest?.balance)
//        }
//        updatePlayer()
//    }
//    func updatePlayer() {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let mainNavigationVC = mainStoryBoard.instantiateViewController(withIdentifier: "CasinoNavigator") as? CasinoNavigator else {
//            return
//        }
//        //print(mainNavigationVC.topViewController)
//        //print(mainNavigationVC.viewControllers)
//        
//        if let mainVC = mainNavigationVC.topViewController as? CasinoFoyerController {
//            mainVC.guest = guest
//        }
//    }
//    func card(split: Int) {
        //print(game.points[split])
        /*let newCard = */
//        game!.card(handIndex: split)
        //print(game.points[split])
//        switch split {
//        case 1:
//            bDoubleDown1.isHidden = true
//        case 2:
//            bDoubleDown2.isHidden = true
//        default:
//            return
//        }
        //cards?[split][index[split]].image = UIImage(named: newCard)
        //cards?[split][index[split]].isHidden = false
        //index[split] += 1
        //pointLabels?[split].text = "\(game!.points[split])"
//        if game!.bust[split] {
//            switch split {
//            case 1:
//                bCard1.isHidden = true; bStand1.isHidden = true
//            case 2:
//                bCard2.isHidden = true; bCard2.isHidden = true
//            default:
//                return
//            }
//        }
//        if game!.tripleSeven[split] {
//            switch split {
//            case 1:
//                bCard1.isHidden = true; bStand1.isHidden = true;bDoubleDown1.isHidden = true
//            case 2:
//                bCard2.isHidden = true; bCard2.isHidden = true;bDoubleDown2.isHidden = true
//            default:
//                return
//            }
//        }
//        if game!.gameIsOver() {
//            bankDraws()
//        }
//    }
//    func doubleDown(split: Int) {
        //guest?.balance -= game!.stakes[split]
//        game!.doubleDown(handIndex: split)
//        switch split {
//        case 1:
//            lStakes.text = "\(MathHelper.roundFloat(number: game!.stakes[1])) $";bStand1.isHidden = true;bCard1.isHidden = true
//        case 2:
//            lStakes2.text = "\(MathHelper.roundFloat(number: game!.stakes[2])) $";bStand2.isHidden = true;bCard2.isHidden = true
//        default:
//            return
//        }
//        card(split: split)
//        game!.stand[split] = true
//        if !game!.split {
//            bankDraws()
//        }
//        else if game!.gameIsOver() {
//            bankDraws()
//        }
//    }
//    func stand(split: Int) {
//        switch split {
//        case 1:
//            bCard1.isHidden = true; bDoubleDown1.isHidden = true
//        case 2:
//            bCard2.isHidden = true; bDoubleDown2.isHidden = true
//        default:
//            return
//        }
//        game!.stand(handIndex: split)
//        if game!.gameIsOver() {
//            bankDraws()
//        }
//    }
    @IBAction func card(_ sender: UIButton) {
        game!.card(handIndex: sender.tag)
        bSplit.isHidden = true
    }
    @IBAction func doubleDown(_ sender: UIButton) {
        sender.isHidden = true
        bSplit.isHidden = true
        game!.doubleDown(handIndex: sender.tag)
    }
    @IBAction func stand(_ sender: UIButton) {
        bSplit.isHidden = true
        sender.isHidden = true
        game!.stand(handIndex: sender.tag)
    }
    @IBAction func splitHand(_ sender: UIButton) {
        game!.splitHand()
        //bSplit.isHidden = true
        
        //cards?[2][index[2]].image = UIImage(named: game!.cards[2][index[2]].imageDescription())
        //cards?[2][index[2]].isHidden = false
        //index[2] += 1
        //cards?[1][1].isHidden = true
        //index[1] -= 1
        //pointLabels?[1].text = "\(game!.points[1])"
        //pointLabels?[2].text = "\(game!.points[2])"
        //lStakes2.text = "\(game!.stakes[2]) $"
        //lStakes2.isHidden = false
        //pointLabels?[2].isHidden = false
//        if game!.twoAceSplit {
//            self.card(split: 1)
//            self.card(split: 2)
//            self.stand(split: 1)
//            self.stand(split: 2)
//        }
//        else {
//            unhideSplitButtons()
//        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.destination is CasinoFoyerController {
            let foyer = segue.destination as! CasinoFoyerController
            foyer.guest = self.guest
        }
        // Pass the selected object to the new view controller.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        do {
            guest = try DataSaver.retrieveGuest()
            slStakes.maximumValue = guest!.balance
            lBalance.text = "\(Int(guest!.balance)) $"
        }
        catch {
            print(error.localizedDescription)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        try? DataSaver.saveGuest(guest: guest!)
    }

}
