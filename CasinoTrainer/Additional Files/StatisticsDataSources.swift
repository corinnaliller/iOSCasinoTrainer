//
//  StatisticsDataSources.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 09.01.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation
import UIKit
class DataAnalysis : NSObject {
    var bjData = [AbsoluteAndPercent]()
    
    override init() {
        //self.selected = 0
        print("Default-Init Analysis Class")
    }
    init(bjstat: BlackJackStats) {
        let bjTotal = bjstat.gamesWon+bjstat.gamesLost+bjstat.gamesTied
        bjData = [
            AbsoluteAndPercent("total",bjstat.gamesWon+bjstat.gamesTied+bjstat.gamesLost,Float(100)),
            AbsoluteAndPercent("won",bjstat.gamesWon,Float(bjstat.gamesWon)/Float(bjTotal)*100),
            AbsoluteAndPercent("tied",bjstat.gamesTied, Float(bjstat.gamesTied)/Float(bjTotal)*100),
            AbsoluteAndPercent("lost",bjstat.gamesLost,Float(bjstat.gamesLost)/Float(bjTotal)*100),
            AbsoluteAndPercent("had Black Jack",bjstat.hadBlackJack, Float(bjstat.hadBlackJack)/Float(bjTotal)*100),
            AbsoluteAndPercent("won with Black Jack",bjstat.wonWithBlackJack, Float(bjstat.wonWithBlackJack)/Float(bjTotal)*100),
            AbsoluteAndPercent("had Triple Seven",bjstat.hadTripleSeven, Float(bjstat.hadTripleSeven)/Float(bjTotal)*100),
            AbsoluteAndPercent("Bank had Black Jack",bjstat.bankHadBlackJack, Float(bjstat.bankHadBlackJack)/Float(bjTotal)*100),
            AbsoluteAndPercent("Bank won with Black Jack",bjstat.bankWonWithBlackJack, Float(bjstat.bankWonWithBlackJack)/Float(bjTotal)*100),
            AbsoluteAndPercent("insurance was paid out",bjstat.insurancePayouts, Float(bjstat.insurancePayouts)/Float(bjstat.tookInsurance)*100),
            AbsoluteAndPercent("Bank went bust",bjstat.bankWentBust, Float(bjstat.bankWentBust)/Float(bjTotal)*100),
            AbsoluteAndPercent("bust bet won",bjstat.bustBetsWon, Float(bjstat.bustBetsWon)/Float(bjstat.betOnBust)*100),
            AbsoluteAndPercent("doubled down",bjstat.doubledDown, Float(bjstat.doubledDown)/Float(bjTotal)*100),
        ]
        print("init with Player-Data")
    }
}
extension DataAnalysis : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bjData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatisticsCell.self)) as! StatisticsCell
        let strings = bjData[indexPath.row]
        cell.labelText = strings.name
        cell.absoluteText = strings.absoluteString
        cell.percentText = strings.percentString
        return cell
    }
}

class RouletteDataAnalysis : NSObject {
    var rouData = [RouletteAbsoluteAndPercent]()
    init(rouStat: RouletteStats) {
        rouData = [
            RouletteAbsoluteAndPercent(name: "Total inside games", won: rouStat.wonInside, lost:rouStat.numberOfInsideGames-rouStat.wonInside),
            RouletteAbsoluteAndPercent(name: "Total outside games", won: rouStat.wonOutside, lost: rouStat.numberOfOutsideGames-rouStat.wonOutside),
            RouletteAbsoluteAndPercent(name: "Outside: Even", won: rouStat.even[0], lost: rouStat.even[1]),
            RouletteAbsoluteAndPercent(name: "Outside: Odd", won: rouStat.odd[0], lost: rouStat.odd[1]),
            RouletteAbsoluteAndPercent(name: "Outside: Red", won: rouStat.red[0], lost: rouStat.red[1]),
            RouletteAbsoluteAndPercent(name: "Outside: Black", won: rouStat.black[0], lost: rouStat.black[1]),
            RouletteAbsoluteAndPercent(name: "Outside: Low", won: rouStat.low[0], lost: rouStat.low[1]),
            RouletteAbsoluteAndPercent(name: "Outside: High", won: rouStat.high[0], lost: rouStat.high[1]),
            RouletteAbsoluteAndPercent(name: "Straight up", won: rouStat.straightUp[0], lost: rouStat.straightUp[1]),
            RouletteAbsoluteAndPercent(name: "Split", won: rouStat.split[0], lost: rouStat.split[1]),
            RouletteAbsoluteAndPercent(name: "Corner", won: rouStat.corner[0], lost: rouStat.corner[1]),
            RouletteAbsoluteAndPercent(name: "First Three", won: rouStat.firstThree[0], lost: rouStat.firstThree[1]),
            RouletteAbsoluteAndPercent(name: "First Four", won: rouStat.firstFour[0], lost: rouStat.firstFour[1]),
            RouletteAbsoluteAndPercent(name: "Column", won: rouStat.column[0], lost: rouStat.column[1]),
            RouletteAbsoluteAndPercent(name: "Dozen", won: rouStat.dozen[0], lost: rouStat.dozen[1]),
            RouletteAbsoluteAndPercent(name: "Street", won: rouStat.street[0], lost: rouStat.street[1]),
            RouletteAbsoluteAndPercent(name: "Six Line", won: rouStat.sixLine[0], lost: rouStat.sixLine[1])
        ]
        print(rouData)
    }
}
extension RouletteDataAnalysis : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rouData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouletteCell.self)) as! RouletteCell
        let strings = rouData[indexPath.row]
        cell.labelText = strings.name
        cell.wonText = strings.wonString
        cell.lostText = strings.lostString
        cell.percentText = strings.percentString
        return cell
    }
}

class MetaDataAnalysis : NSObject {
    var metaData = [MetaData]()
    
    init(guest: Player) {
        metaData = [
            MetaData(text: "Won alltogether", MathHelper.roundFloat(number: guest.balance - guest.initialCapital)),
            MetaData(text: "Won at Black Jack", guest.bjStats.winsAndLosses.reduce(0,+)),
            MetaData(text: "Won at Roulette", guest.rouStats.winsAndLosses.reduce(0,+)),
            MetaData(text: "Average Black Jack Stakes", MathHelper.roundFloat(number: guest.bjStats.allStakes.reduce(0,+)/Float(guest.bjStats.allStakes.count))),
            MetaData(text: "Average Roulette Stakes", guest.rouStats.allStakes.reduce(0,+) / Float(guest.rouStats.allStakes.count)),
            MetaData(text: "Average Black Jack Wins", MathHelper.roundFloat(number: guest.bjStats.winsAndLosses.reduce(0,+)/Float(guest.bjStats.winsAndLosses.count))),
            MetaData(text: "Average Roulette Wins", MathHelper.roundFloat(number: guest.rouStats.winsAndLosses.reduce(0,+)/Float(guest.rouStats.winsAndLosses.count))),
            MetaData(text: "Average Insurance Payouts (Black Jack)", guest.bjStats.insurances.reduce(0,+)/Float(guest.bjStats.insurances.count)),
            MetaData(text: "Average Bust Bet Payout", guest.bjStats.bustBets.reduce(0, +)/Float(guest.bjStats.bustBets.count))
        ]
    }
}
extension MetaDataAnalysis : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MetaStatisticsCell.self)) as! MetaStatisticsCell
        let strings = metaData[indexPath.row]
        cell.labelText = strings.name
        cell.absoluteText = strings.numberString
        return cell
    }
    
    
}
