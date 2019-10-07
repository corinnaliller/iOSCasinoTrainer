//
//  StatisticsChoiceController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import UIKit

class StatisticsChoiceController: UIViewController {

    var guest: Player?
    var dbPointer: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func goToTable(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            performSegue(withIdentifier: "showBlackJackStatistics", sender: self)
//        case 2:
//            if rougames != 0 {performSegue(withIdentifier: "showRouletteStatistics", sender: self)}
//        case 3:
//            if (bjgames+rougames) != 0 {performSegue(withIdentifier: "showMetaStatistics", sender: self)}
        default:
            return
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.destination is BlackJackStatisticsController {
            let bj = segue.destination as! BlackJackStatisticsController
            bj.guest = self.guest
            bj.dbPointer = self.dbPointer
        }
        else if segue.destination is RouletteStatisticsController {
            let rou = segue.destination as! RouletteStatisticsController
            rou.guest = self.guest
        }
        else if segue.destination is MetaStatisticsController {
            let meta = segue.destination as! MetaStatisticsController
            meta.guest = self.guest
        }
        // Pass the selected object to the new view controller.
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

}
