//
//  DatabaseSelectResults.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 09.05.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

struct GeneralBlackJackStatistics {
    let allStats: [[BlackJackOutcomes:Int]]
    
    init() {
        allStats = [
            [
                BlackJackOutcomes.gamesWon:0,
                BlackJackOutcomes.gamesTied:0,
                BlackJackOutcomes.gamesLost:0
            ],
            [
                BlackJackOutcomes.hadBlackJack: 0,
                BlackJackOutcomes.wonWithBlackJack: 0,
                BlackJackOutcomes.hadTripleSeven: 0,
                BlackJackOutcomes.playerWentBust: 0
            ],
            [
                BlackJackOutcomes.bankHadBlackJack: 0,
                BlackJackOutcomes.tookInsurance: 0,
                BlackJackOutcomes.insuranceWasPaidOut: 0,
                BlackJackOutcomes.bankWentBust: 0,
                BlackJackOutcomes.betOnBust: 0,
                BlackJackOutcomes.bustBetsWon: 0
            ],
            [
                BlackJackOutcomes.doubledDown: 0,
                BlackJackOutcomes.wonAfterDoubleDown: 0
            ]
        ]
    }
    init(general: [Int], player: [Int], bank: [Int], extra: [Int]) {
        allStats = [
            [
                BlackJackOutcomes.gamesWon: general[0],
                BlackJackOutcomes.gamesTied:general[1],
                BlackJackOutcomes.gamesLost:general[2]
            ],
            [
                BlackJackOutcomes.hadBlackJack: player[0],
                BlackJackOutcomes.wonWithBlackJack: player[1],
                BlackJackOutcomes.hadTripleSeven: player[2],
                BlackJackOutcomes.playerWentBust: player[3]
            ],
            [
                BlackJackOutcomes.bankHadBlackJack: bank[0],
                BlackJackOutcomes.tookInsurance: bank[1],
                BlackJackOutcomes.insuranceWasPaidOut: bank[2],
                BlackJackOutcomes.bankWentBust: bank[3],
                BlackJackOutcomes.betOnBust: bank[4],
                BlackJackOutcomes.bustBetsWon: bank[5]
            ],
            [
                BlackJackOutcomes.doubledDown: extra[0],
                BlackJackOutcomes.wonAfterDoubleDown: extra[1]
            ]
        ]
        printData()
    }
    private func printData() {
        for sections in allStats {
            for outcomes in sections {
                print("\(outcomes.key.rawValue): \(outcomes.value)")
            }
        }
    }
}
