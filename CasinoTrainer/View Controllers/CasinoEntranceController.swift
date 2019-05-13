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
    @IBOutlet weak var bEnterAs: UIButton!
    let db = try! SQLiteDatabase.open(path: Database.CasinoTrainer.rawValue)
    var logout: Bool = false
    var guest: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try db.createTable(table: CasinoGuest.self)
            try db.createTable(table: BlackJackGame.self)
            try db.createTable(table: BlackJackBustBet.self)
            try db.createTable(table: BlackJackInsurance.self)
        }
        catch {
            if error is SQLiteError {
                let e = error as! SQLiteError
                print(e.localizedDescription)
            }
        }
        do {
            guest = try DataSaver.retrieveGuest()
        }
        catch {
            print(error.localizedDescription)
        }
        if guest != nil {
            bEnterAs.setTitle("Enter as \(guest!.playerName)", for: .normal)
            bEnterAs.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setCapital(_ sender: Any) {
        lMoney.text = "\(MathHelper.roundFloat(number: slCapital.value)) $"
    }
    
    @IBAction func enterAgain(_ sender: UIButton) {
        if guest?.playerName != "Placeholder" {
            performSegue(withIdentifier: "enterCasino", sender: self)
        }
    }
    @IBAction func enterCasino(_ sender: Any) {
        if tUserName.text != "" {
           //navigateToFoyer()
            logout = true
            performSegue(withIdentifier: "enterCasino", sender: self)
        }
        
        
    }
//    private func navigateToFoyer() {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let mainNavigationVC = mainStoryBoard.instantiateViewController(withIdentifier: "CasinoNavigator") as? CasinoNavigator else {
//            return
//        }
//        //print(mainNavigationVC.topViewController)
//        //print(mainNavigationVC.viewControllers)
//        
//        if let mainVC = mainNavigationVC.topViewController as? CasinoFoyerController {
//            //mainVC.guest = Player(name: tUserName.text!, capital: slCapital.value)
//        }
//        present(mainNavigationVC, animated: true, completion: nil)
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navi = segue.destination as? CasinoNavigator {
            var id = 0
            let foyer = navi.viewControllers.first as! CasinoFoyerController
            do {
                id = try db.insertPlayer(tUserName.text!, capital: MathHelper.roundFloat(number: slCapital.value))
                if logout {
                    foyer.guest = Player(guest: try db.getPlayer(id: id)!)
                }
                else {
                    foyer.guest = self.guest
                }
            }
            catch {
                print("Could not save Guest!")
            }
            
            
        }
        
    }
    

}
