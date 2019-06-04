//
//  CasinoEntranceController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class CasinoEntranceController: UIViewController {
    @IBOutlet weak var tUserName: UITextField!
    @IBOutlet weak var slCapital: UISlider!
    @IBOutlet weak var lMoney: UILabel!
    @IBOutlet weak var bEnter: UIButton!
    @IBOutlet weak var segCtrlLogin: UISegmentedControl!
//    var db: SQLiteDatabase = SQLiteDatabase(dbPointer: nil)
    var dbController: DatabaseController = DatabaseController()
    var logout: Bool = false
    var guest: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            try db = SQLiteDatabase.open(path: Database.CasinoTrainer.path)
//            try db.createTable(table: CasinoGuest.self)
//            try db.createTable(table: BlackJackGame.self)
//            try db.createTable(table: BlackJackBustBet.self)
//            try db.createTable(table: BlackJackInsurance.self)
//            try db.createTable(table: RouletteGame.self)
//        }
//        catch {
//            if error is SQLiteError {
//                let e = error as! SQLiteError
//                print(e.localizedDescription)
//            }
//        }
        do {
            guest = try DataSaver.retrieveGuest()
        }
        catch {
            print(error.localizedDescription)
        }
        if guest != nil {
            segCtrlLogin.selectedSegmentIndex = 1
            slCapital.isHidden = true
            tUserName.text = guest!.playerName
            bEnter.setTitle("Enter as \(guest!.playerName)", for: .normal)
        }
        else {
            segCtrlLogin.selectedSegmentIndex = 0
            slCapital.isHidden = false
            tUserName.text = nil
            bEnter.setTitle("Register and Enter", for: .normal)
        }
    }
    
    @IBAction func setCapital(_ sender: Any) {
        lMoney.text = "\(MathHelper.roundFloat(number: slCapital.value)) $"
    }
    
    @IBAction func registerOrLogin(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            slCapital.isHidden = false; bEnter.setTitle("Register and Enter", for: .normal); lMoney.isHidden = false
        case 1:
            slCapital.isHidden = true; bEnter.setTitle("Enter as guest", for: .normal); lMoney.isHidden = true
        default:
            return
        }
    }
    
    @IBAction func enterCasino(_ sender: Any) {
        if tUserName.text != "" {
            if segCtrlLogin.selectedSegmentIndex == 1 {
                let casinoGuest = dbController.getPlayer(name: tUserName.text!)
                print(casinoGuest?.description() ?? "Nobody")
                if casinoGuest != nil {
                    self.guest = Player(guest: casinoGuest!)
                    performSegue(withIdentifier: "enterCasino",sender: self)
                }
                else {
                    print("You have not been here before!")
                }

            }
            else {
                let newId = dbController.insertPlayer(tUserName.text!, capital: MathHelper.roundFloat(number: slCapital.value))
                print(newId ?? "Nothing")
                if newId != nil {
                    self.guest = Player(id: newId!, name: tUserName.text!, capital: slCapital.value)
                    performSegue(withIdentifier: "enterCasino", sender: self)
                }

            }
        }
    }
    
    private func navigateToFoyer() {
        
        print("Navigation to foyer")
        let foyer: CasinoFoyerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CasinoFoyer") as! CasinoFoyerController
        foyer.guest = self.guest
        try? DataSaver.saveGuest(guest: guest!)
        self.navigationController?.pushViewController(foyer, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? CasinoNavigator {
            let foyer = navi.viewControllers.first as! CasinoFoyerController
            foyer.guest = self.guest
            try? DataSaver.saveGuest(guest: guest!)
            foyer.dbPointer = dbController.getPointer()
        }

    }
    

}
