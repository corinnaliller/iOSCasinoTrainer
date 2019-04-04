//
//  StatisticsController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class BlackJackStatisticsController: UIViewController {

    @IBOutlet weak var statisticsTable: UITableView!
    var guest: Player?
    var dataSource: DataAnalysis
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(guest?.bjStats.gamesWon)
//        print(guest?.bjStats.gamesTied)
//        print(guest?.bjStats.gamesLost)
        // Do any additional setup after loading the view.
        if guest != nil {
            dataSource = DataAnalysis(bjstat: guest!.bjStats)
        }
        statisticsTable.estimatedRowHeight = 113
        statisticsTable.rowHeight = UITableView.automaticDimension
        statisticsTable.dataSource = dataSource
        statisticsTable.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.dataSource = DataAnalysis(bjstat: BlackJackStats())
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.destination is StatisticsChoiceController {
            let entrance = segue.destination as! StatisticsChoiceController
            entrance.guest = self.guest
        }
        // Pass the selected object to the new view controller.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        DataSaver.saveGuest(guest: guest!)
    }
}
