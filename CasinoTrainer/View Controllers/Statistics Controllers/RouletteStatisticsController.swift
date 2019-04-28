//
//  RouletteStatisticsController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import UIKit

class RouletteStatisticsController: UIViewController {

    @IBOutlet weak var rouletteTable: UITableView!
    var guest: Player?
    var dataSource: RouletteDataAnalysis
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if guest != nil {
            dataSource = RouletteDataAnalysis(rouStat: guest!.rouStats)
        }
        rouletteTable.estimatedRowHeight = 113
        rouletteTable.rowHeight = UITableView.automaticDimension
        rouletteTable.dataSource = dataSource
        rouletteTable.reloadData()
        // Do any additional setup after loading the view.
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.dataSource = RouletteDataAnalysis(rouStat: RouletteStats())
        super.init(coder: aDecoder)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.destination is StatisticsChoiceController {
            let back = segue.destination as! StatisticsChoiceController
            back.guest = self.guest
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
        try? DataSaver.saveGuest(guest: guest!)
    }
}
