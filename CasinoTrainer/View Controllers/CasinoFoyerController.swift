//
//  ViewController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class CasinoFoyerController: UIViewController {

    var guest: Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(guest?.playerName ?? "Nobody")")
        print("\(guest?.bjStats.gamesWon ?? 0)")
        print("\(guest?.bjStats.gamesTied ?? 0)")
        print("\(guest?.bjStats.gamesLost ?? 0)")
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(guest?.playerName ?? "Nobody")")
        print("\(guest?.bjStats.gamesWon ?? 0)")
        print("\(guest?.bjStats.gamesTied ?? 0)")
        print("\(guest?.bjStats.gamesLost ?? 0)")
        if segue.destination is BlackJackController {
            let jack = segue.destination as! BlackJackController
            jack.guest = self.guest
        }
        else if segue.destination is RouletteController {
            let roulette = segue.destination as! RouletteController
            roulette.guest = self.guest
        }
        else if segue.destination is StatisticsChoiceController {
            let table = segue.destination as! StatisticsChoiceController
            table.guest = self.guest
        }
    }
    @IBAction func goToRoulette(_ sender: UIButton) {
        let rouletteVC: RouletteController = UIStoryboard(name: "Roulette", bundle: nil).instantiateInitialViewController() as! RouletteController
        self.navigationController?.pushViewController(rouletteVC, animated: true)
    }
    @IBAction func goToBlackJack(_ sender: UIButton) {
        let blackJackVC: BlackJackController = UIStoryboard(name: "Blackjack", bundle: nil).instantiateInitialViewController() as! BlackJackController
        self.navigationController?.pushViewController(blackJackVC, animated: true)
    }
    @IBAction func showStatistics(_ sender: UIButton) {
        print("\(guest?.playerName ?? "Nobody")")
        print("\(guest?.bjStats.gamesWon ?? 0)")
        print("\(guest?.bjStats.gamesTied ?? 0)")
        print("\(guest?.bjStats.gamesLost ?? 0)")
        performSegue(withIdentifier: "showStatistics", sender: self)

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

