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
    var rouData: [[RouletteAbsoluteAndPercent]]
    let headers = ["General", "Outside", "Inside"]
    init(rouStat: RouletteStats) {
        rouData = [
            [RouletteAbsoluteAndPercent(name: "Total inside games", won: rouStat.wonInside, lost:rouStat.numberOfInsideGames-rouStat.wonInside),
            RouletteAbsoluteAndPercent(name: "Total outside games", won: rouStat.wonOutside, lost: rouStat.numberOfOutsideGames-rouStat.wonOutside)],
            [RouletteAbsoluteAndPercent(name: "Even", won: rouStat.outsideOutcomes[Outside.even]![0], lost: rouStat.outsideOutcomes[Outside.even]![1]),
            RouletteAbsoluteAndPercent(name: "Odd", won: rouStat.outsideOutcomes[Outside.odd]![0], lost: rouStat.outsideOutcomes[Outside.odd]![1]),
            RouletteAbsoluteAndPercent(name: "Red", won: rouStat.outsideOutcomes[Outside.red]![0], lost: rouStat.outsideOutcomes[Outside.red]![1]),
            RouletteAbsoluteAndPercent(name: "Black", won: rouStat.outsideOutcomes[Outside.black]![0], lost: rouStat.outsideOutcomes[Outside.black]![1]),
            RouletteAbsoluteAndPercent(name: "Low", won: rouStat.outsideOutcomes[Outside.low]![0], lost: rouStat.outsideOutcomes[Outside.low]![1]),
            RouletteAbsoluteAndPercent(name: "High", won: rouStat.outsideOutcomes[Outside.high]![0], lost: rouStat.outsideOutcomes[Outside.high]![1])],
            [RouletteAbsoluteAndPercent(name: "Straight up", won: rouStat.insideOutcomes[Inside.straightUp]![0], lost: rouStat.insideOutcomes[Inside.straightUp]![1]),
            RouletteAbsoluteAndPercent(name: "Split", won: rouStat.insideOutcomes[Inside.split]![0], lost: rouStat.insideOutcomes[Inside.split]![1]),
            RouletteAbsoluteAndPercent(name: "Corner", won: rouStat.insideOutcomes[Inside.corner]![0], lost: rouStat.insideOutcomes[Inside.corner]![1]),
            RouletteAbsoluteAndPercent(name: "First Three", won: rouStat.insideOutcomes[Inside.firstThree]![0], lost: rouStat.insideOutcomes[Inside.firstThree]![1]),
            RouletteAbsoluteAndPercent(name: "First Four", won: rouStat.insideOutcomes[Inside.firstFour]![0], lost: rouStat.insideOutcomes[Inside.firstFour]![1]),
            RouletteAbsoluteAndPercent(name: "Column", won: rouStat.insideOutcomes[Inside.column]![0], lost: rouStat.insideOutcomes[Inside.column]![1]),
            RouletteAbsoluteAndPercent(name: "Dozen", won: rouStat.insideOutcomes[Inside.dozen]![0], lost: rouStat.insideOutcomes[Inside.dozen]![1]),
            RouletteAbsoluteAndPercent(name: "Street", won: rouStat.insideOutcomes[Inside.street]![0], lost: rouStat.insideOutcomes[Inside.street]![1]),
            RouletteAbsoluteAndPercent(name: "Six Line", won: rouStat.insideOutcomes[Inside.sixLine]![0], lost: rouStat.insideOutcomes[Inside.sixLine]![1])]
        ]
        print(rouData)
    }
}
extension RouletteDataAnalysis : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rouData.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RouletteCell.self)) as! RouletteCell
        let strings = rouData[indexPath.section][indexPath.row]
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
