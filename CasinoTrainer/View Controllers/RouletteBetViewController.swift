//
//  RouletteBetViewController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 12.12.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class RouletteBetViewController: UIViewController {
    @IBOutlet weak var fullNumberStackView: UIStackView!
    @IBOutlet weak var outsideStackView: UIStackView!
    @IBOutlet weak var dozenStackView: UIStackView!
    @IBOutlet weak var columnStackView: UIStackView!
    
    @IBOutlet weak var lMessage: UILabel!
    @IBOutlet weak var betTypes: UISegmentedControl!
    @IBOutlet weak var bZero: UIButton!
    @IBOutlet weak var bSetBet: UIButton!
    @IBOutlet weak var split1: UIButton!
    @IBOutlet weak var split2: UIButton!
    
    var fullNumberButtons = [UIButton]()
    var outsideButtons = [UIButton]()
    var dozenButtons = [UIButton]()
    var columnButtons = [UIButton]()
    var selectedNumber = 37
    var splitNumber = 0
    var bet: RouletteBet?
    var guest: Player?
    override func viewDidLoad() {
        super.viewDidLoad()

        betTypes.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        for view in betTypes.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UILabel.self) {
                    subview.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
            }
        }
 
        fullNumberButtons.append(bZero)
        for case let fullNumberStackView as UIStackView in fullNumberStackView.arrangedSubviews {
            for case let button as UIButton in fullNumberStackView.arrangedSubviews {
                fullNumberButtons.append(button)
                //button.setTitle(String(button.tag), for: .normal)
            }
        }
        for case let button as UIButton in outsideStackView.arrangedSubviews {
            outsideButtons.append(button)
            //button.setTitle(String(button.tag), for: .normal)
        }
        for case let button as UIButton in dozenStackView.arrangedSubviews {
            dozenButtons.append(button)
            //button.setTitle(String(button.tag), for: .normal)
        }
        for case let button as UIButton in columnStackView.arrangedSubviews {
            columnButtons.append(button)
            //button.setTitle(String(button.tag), for: .normal)
        }
        hideFullNumberButtons()
        hideColumnButtons()
        hideDozenButtons()
        hideSplitButtons()
        //hideOutsideButtons()
        //hideForCorner()
    }
    func hideForCorner() {
        for b in fullNumberButtons {
            if (b.tag % 3) == 0 || b.tag == 34 || b.tag == 35 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideForStreet() {
        for b in fullNumberButtons {
            if (b.tag % 3) == 0 || (b.tag % 3) == 2 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideForSixLine() {
        for b in fullNumberButtons {
            if (b.tag % 3) == 0 || (b.tag % 3) == 2 || b.tag == 34 {
                b.isHidden = true
            }
            else {
                b.isHidden = false
            }
        }
    }
    func hideFullNumberButtons() {
        for b in fullNumberButtons {
            b.isHidden = true
        }
    }
    func hideOutsideButtons() {
        for b in outsideButtons {
            b.isHidden = true
        }
    }
    func hideColumnButtons() {
        for b in columnButtons {
            b.isHidden = true
        }
    }
    func hideDozenButtons() {
        for b in dozenButtons {
            b.isHidden = true
        }
    }
    func hideSplitButtons() {
        split1.isHidden = true
        split2.isHidden = true
    }
    func unhideFullNumberButtons() {
        for b in fullNumberButtons {
            b.isHidden = false
        }
    }
    func unhideOutsideButtons() {
        for b in outsideButtons {
            b.isHidden = false
        }
    }
    func unhideColumnButtons() {
        for b in columnButtons {
            b.isHidden = false
        }
    }
    func unhideDozenButtons() {
        for b in dozenButtons {
            b.isHidden = false
        }
    }
    func unhideSplitButtons(number: Int) {
        if (number % 3) == 0 {
            if number == 36 {
                lMessage.text = "No split possible"
            }
            else {
                split2.isHidden = false
            }
        }
        else if number == 34 || number == 35 {
           split1.isHidden = false
        }
        else {
            split1.isHidden = false
            split2.isHidden = false
        }
        
    }
    func resetButtons(collection: String) {
        let coll: [UIButton]
        switch collection {
        case "full":
            coll = fullNumberButtons
        case "column":
            coll = columnButtons
        case "dozen":
            coll = dozenButtons
        case "outside":
            coll = outsideButtons
        default:
            return
        }
        
        for b in coll {
            b.backgroundColor = UIColor.lightGray
            b.alpha = 0.6
            b.setImage(nil, for: .normal)
        }
    }
    func selectFullNumber(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        lMessage.text = "\(selectedNumber)"
    }
    func selectSplitNumber(sender: UIButton) {
        resetButtons(collection: "full")
        hideSplitButtons()
        bSetBet.isHidden = true
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        lMessage.text = "Split \(selectedNumber)"
        unhideSplitButtons(number: selectedNumber)
    }
    func selectCorner(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        lMessage.text = "Corner \(selectedNumber): \(selectedNumber), \(selectedNumber+1), \(selectedNumber+3), \(selectedNumber+4)"
    }
    func selectSixLine(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        lMessage.text = "Six Line \(selectedNumber)"
    }
    func selectStreet(sender: UIButton) {
        resetButtons(collection: "full")
        sender.backgroundColor = nil
        sender.alpha = 1
        sender.setImage(UIImage(named: "Chips"), for: .normal)
        selectedNumber = sender.tag
        lMessage.text = "Street \(selectedNumber)"
    }
    @IBAction func selectBetType(_ sender: UISegmentedControl) {
        selectedNumber = 37
        splitNumber = 0
        lMessage.text = ""
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
        case 8: hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideFullNumberButtons();lMessage.text="First Three";hideSplitButtons();selectedNumber = 0
        case 9:
            hideOutsideButtons();hideDozenButtons();hideColumnButtons();hideFullNumberButtons();lMessage.text="First Four";hideSplitButtons();selectedNumber = 0
        default:
            return
        }
    }
    @IBAction func selectSplit(_ sender: UIButton) {
        splitNumber = sender.tag
        bSetBet.isHidden = false
        hideSplitButtons()
    }
    @IBAction func selectColumnBet(_ sender: UIButton) {
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
        lMessage.text = "\(count) Column"
    }
    @IBAction func selectDozenBet(_ sender: UIButton) {
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
        lMessage.text = "\(count) Dozen"
    }
    @IBAction func selectOutsideBet(_ sender: UIButton) {
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
        lMessage.text = "\(out) Numbers"
    }
    @IBAction func selectFullNumber(_ sender: UIButton) {
        switch betTypes.selectedSegmentIndex {
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
    @IBAction func placeRouletteBet(_ sender: UIButton) {
        if selectedNumber != 37 {
            if betTypes.selectedSegmentIndex == 0 {
                let type: Outside
                switch selectedNumber {
                case 1: type = Outside.low
                case 2: type = Outside.even
                case 3: type = Outside.red
                case 4: type = Outside.black
                case 5: type = Outside.odd
                case 6: type = Outside.high
                default: return
                }
                bet = OutsideBet(type: type)
            }
            else {
                let type: Inside
                switch betTypes.selectedSegmentIndex {
                case 1: type = Inside.straightUp
                case 2: type = Inside.dozen
                case 3: type = Inside.column
                case 4: type = Inside.corner
                case 5: type = Inside.split
                case 6: type = Inside.sixLine
                case 7: type = Inside.street
                case 8: type = Inside.firstThree
                case 9: type = Inside.firstFour
                default: return
                }
                bet = InsideBet(type: type, number: selectedNumber, def: splitNumber)
            }
            let rouVC: RouletteController = UIStoryboard(name: "Roulette", bundle: nil).instantiateInitialViewController() as! RouletteController
            rouVC.bet = bet
            self.navigationController?.popToViewController(rouVC, animated: true)
            
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is RouletteController {
            let table = segue.destination as! RouletteController
            table.bet = self.bet
            table.guest = self.guest
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        try? DataSaver.saveGuest(guest: guest!)
    }

}
