//
//  MetaStatisticsCell.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import UIKit

class MetaStatisticsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var labelText: String? {
        didSet {
            nameLabel.text = labelText
        }
    }
    var absoluteText: String? {
        didSet {
            numberLabel.text = absoluteText
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
