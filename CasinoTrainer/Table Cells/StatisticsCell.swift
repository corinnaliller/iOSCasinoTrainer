//
//  StatisticsCell.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 19.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell {
    @IBOutlet weak var lText: UILabel!
    @IBOutlet weak var lAbsolute: UILabel!
    @IBOutlet weak var lPercent: UILabel!
    
    var labelText: String? {
        didSet {
            lText.text = labelText
        }
    }
    var absoluteText: String? {
        didSet {
            lAbsolute.text = absoluteText
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
