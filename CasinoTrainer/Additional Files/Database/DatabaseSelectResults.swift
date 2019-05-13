//
//  DatabaseSelectResults.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 09.05.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

struct GeneralBlackJackStatistics {
    let allStats: [BlackJackOutcomes:Int]
    
    init() {
        allStats = [
            BlackJackOutcomes.gamesWon:0,
            BlackJackOutcomes.gamesTied:0
        ]
    }
}
