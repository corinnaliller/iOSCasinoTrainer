//
//  RouletteController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class RouletteController: UIViewController {

    @IBOutlet weak var bSelectBet: UIButton!
    @IBOutlet weak var lBet: UILabel!
    @IBOutlet weak var lWin: UILabel!
    @IBOutlet weak var lResult: UILabel!
    @IBOutlet weak var slStakes: UISlider!
    @IBOutlet weak var lStakes: UILabel!
    @IBOutlet weak var bRienNeVasPlus: UIButton!
    @IBOutlet weak var lBalance: UILabel!
    let minimum = 10
    var bet: RouletteBet?
    var guest: Player?
    let roulette = RouletteLogicController()
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(guest?.playerName)
        
        lResult.isHidden = true
        lWin.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        do {
            guest = try DataSaver.retrieveGuest()
            lBalance.text = "Balance: \(MathHelper.roundFloat(number: guest!.balance)) $"
        }
        catch {
            print(error.localizedDescription)
        }
        if bet == nil {
            bRienNeVasPlus.isHidden = true
            lBet.text = "No bet selected"
            slStakes.isHidden = true
            lStakes.isHidden = true
            bSelectBet.isHidden=false        }
        else {
            bSelectBet.isHidden=true
            if bet is OutsideBet {
                let out = bet as! OutsideBet
                print(out.description())
            }
            else if bet is InsideBet {
                let ins = bet as! InsideBet
                print(ins.description())
            }
            bRienNeVasPlus.isHidden = false
            slStakes.value = Float(minimum)
            slStakes.minimumValue = Float(minimum)
            if guest!.balance < (Float((1200 * minimum) / (bet!.payout - 1))) {
                slStakes.maximumValue = guest!.balance
            }
            else {
                slStakes.maximumValue = Float((1200 * minimum) / (bet!.payout - 1))
            }
            lBalance.text = "Balance: \(MathHelper.roundFloat(number: guest!.balance-slStakes.value)) $"
            slStakes.isHidden = false
            lStakes.text = "\(MathHelper.roundFloat(number:slStakes.value)) $"
            lStakes.isHidden = false
            if bet is InsideBet {
                let b = bet as! InsideBet
                lBet.text = "\(b.description())"
            }
            else if bet is OutsideBet {
                let b = bet as! OutsideBet
                lBet.text = "\(b.description())"
            }
            else {
                lBet.text = "Something went wrong!"
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        try? DataSaver.saveGuest(guest: guest!)
    }
    
    @IBAction func rienNeVasPlus(_ sender: UIButton) {
        if bet != nil && sender.title(for: .normal) == "rien ne vas plus" {
            bSelectBet.isHidden = true
            slStakes.isHidden = true
            sender.setTitle("Play again", for: .normal)
            guest!.balance -= slStakes.value
            lBalance.text = "Balance: \(MathHelper.roundFloat(number: guest!.balance)) $"
            let result = roulette.rienNeVasPlus(bet: bet!, stakes: MathHelper.roundFloat(number: slStakes.value))
            print(result.description())
            if result.winningNumber.color == RouletteColor.black {
                lResult.textColor = UIColor.black
            }
            else if result.winningNumber.color == RouletteColor.red {
                lResult.textColor = UIColor.red
            }
            else {
                lResult.textColor = UIColor.green
            }
            lResult.text = "\(result.winningNumber.number)"
            lResult.isHidden = false
            guest!.endRoulette(outcome: result)
            if result.outcome {
                lWin.text = "\(result.prize) $"
            }
            else {
                lWin.text = "You lost"
            }
            lWin.isHidden = false
            lBalance.text = "Balance: \(MathHelper.roundFloat(number: guest!.balance)) $"
        }
        else if sender.title(for: .normal) == "Play again" {
            bet = nil
            sender.setTitle("rien ne vas plus", for: .normal)
            sender.isHidden = true
            bSelectBet.isHidden = false
            lResult.isHidden = true
            lWin.isHidden = true
            lBet.text = "No bet selected"
        }
       
    }
    @IBAction func selectStakes(_ sender: UISlider) {
        lStakes.text = "\(MathHelper.roundFloat(number: sender.value)) $"
        lBalance.text = "Balance: \(MathHelper.roundFloat(number:guest!.balance-sender.value)) $"
    }
    @IBAction func selectBet(_ sender: UIButton) {
        performSegue(withIdentifier: "selectRouletteBet", sender: self)
        //self.navigationController?.popViewController(animated: false)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CasinoFoyerController {
            let foyer = segue.destination as! CasinoFoyerController
            foyer.guest = self.guest
        }
        else if segue.destination is RouletteBetViewController {
            let tableau = segue.destination as! RouletteBetViewController
            tableau.guest = self.guest
        }
    }
    

}
