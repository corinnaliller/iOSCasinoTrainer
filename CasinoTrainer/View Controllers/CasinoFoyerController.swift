//
//  ViewController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class CasinoFoyerController: UIViewController {

    var logoutBtn: UIBarButtonItem?
    var dbPointer: OpaquePointer?
    var guest: Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutBtn!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        rouletteVC.guest = self.guest
        //rouletteVC.dbPointer = self.dbPointer
        self.navigationController?.pushViewController(rouletteVC, animated: true)
    }
    @IBAction func goToBlackJack(_ sender: UIButton) {
        let blackJackVC: BlackJackController = UIStoryboard(name: "Blackjack", bundle: nil).instantiateInitialViewController() as! BlackJackController
        blackJackVC.guest = self.guest
        blackJackVC.dbPointer = self.dbPointer
        self.navigationController?.pushViewController(blackJackVC, animated: true)
    }
    @IBAction func goToStatistics(_ sender: UIButton) {
        let statVC: StatisticsChoiceController = UIStoryboard(name: "Statistics", bundle: nil).instantiateInitialViewController() as! StatisticsChoiceController
        statVC.guest = self.guest
        //statVC.dbPointer = self.dbPointer
        self.navigationController?.pushViewController(statVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        do {
           guest = try DataSaver.retrieveGuest()
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
    @objc private func logout() {
        performSegue(withIdentifier: "leaveCasino", sender: self)
    }
}

