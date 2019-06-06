//
//  MetaStatisticsController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import UIKit

class MetaStatisticsController: UIViewController {

    var guest: Player?
    @IBOutlet weak var metaTableView: UITableView!
    //var dataSource: MetaDataAnalysis
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if guest != nil {
            //dataSource = MetaDataAnalysis(guest: guest!)
        }
        metaTableView.estimatedRowHeight = 113
        metaTableView.rowHeight = UITableView.automaticDimension
        //metaTableView.dataSource = dataSource
        metaTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    required init?(coder aDecoder: NSCoder) {
        
        //self.dataSource = MetaDataAnalysis(guest: Player())
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
        try? DataSaver.saveGuest(guest: guest!)
    }

}
