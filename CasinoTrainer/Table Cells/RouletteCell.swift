//
//  RouletteCell.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import UIKit

class RouletteCell: UITableViewCell {

    @IBOutlet weak var lText: UILabel!
    @IBOutlet weak var lWon: UILabel!
    @IBOutlet weak var lLost: UILabel!
    @IBOutlet weak var lPercent: UILabel!
    
    var labelText: String? {
        didSet {
            lText.text = labelText
        }
    }
    var wonText: String? {
        didSet {
            lWon.text = wonText
        }
    }
    var lostText: String? {
        didSet {
            lLost.text = lostText
        }
    }
    var percentText: String? {
        didSet {
            lPercent.text = percentText
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
