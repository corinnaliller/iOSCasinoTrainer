//
//  Statistics.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation
import UIKit

class Player  /*: NSObject, NSCoding*/ {
    
    var playerName: String
    var initialCapital: Float
    var balance: Float
    var bjStats: BlackJackStats
    var rouStats: RouletteStats
    init() {
        playerName = "Placeholder"
        balance = 10
        initialCapital = 20
        bjStats = BlackJackStats(standard: 1)
        rouStats = RouletteStats()
    }
    
    init(name: String, capital: Float) {
        playerName = name
        initialCapital = capital
        balance = initialCapital
        bjStats = BlackJackStats()
        rouStats = RouletteStats()
    }
    
    init(name: String, capital:Float, balance: Float, bjStatData: [String:Int], rouStatData: [String:[Int]], otherArrays: [String:[Float]]) {
        self.playerName = name
        self.initialCapital = capital
        self.balance = balance
        bjStats = BlackJackStats(statData: bjStatData, stakes: otherArrays["Black Jack stakes"]!, winAndLose: otherArrays["Black Jack WinsAndLosses"]!, insurances: otherArrays["Black Jack insurances"]!, bustBets: otherArrays["Black Jack bust bets"]!)
        rouStats = RouletteStats(statData: rouStatData, winAndLose: otherArrays["Roulette WinsAndLosses"]!, stakes: otherArrays["Roulette stakes"]!)
        
    }
    /*
    func encode(with aCoder: NSCoder) {
        
    }
    required init?(coder aDecoder: NSCoder) {
        self.playerName = aDecoder.decodeObject(forKey:"name") as! String
    }
*/
    func arraysToDictionary() -> [String: [Float]] {
        let dic = [ "Black Jack WinsAndLosses": bjStats.winsAndLosses, "Black Jack stakes": bjStats.allStakes, "Black Jack insurances": bjStats.insurances, "Black Jack bust bets": bjStats.bustBets, "Roulette WinsAndLosses": rouStats.winsAndLosses, "Roulette stakes": rouStats.allStakes]
        return dic
    }
    func endBlackJack(outcome: BlackJackGameOver) {
        switch outcome.winOrLose {
        case .lost:
            bjStats.gamesLost += 1
            bjStats.winsAndLosses.append(-outcome.stakesMoney)
        case .tie:
            bjStats.gamesTied += 1
            bjStats.winsAndLosses.append(0)
        case .won:
            bjStats.gamesWon += 1
            bjStats.winsAndLosses.append(outcome.prizeMoney)
        case .bjwon:
            bjStats.gamesWon += 1
            bjStats.wonWithBlackJack += 1
            bjStats.winsAndLosses.append(outcome.prizeMoney)
        }
        balance += outcome.prizeMoney + outcome.insurancePayout + outcome.bustBetPayout
        bjStats.allStakes.append(outcome.stakesMoney)
        bjStats.bustBets.append(outcome.bustBetPayout)
        if outcome.tookInsurance {
            balance += outcome.insurancePayout
            bjStats.tookInsurance += 1
            if outcome.insurancePayout > 0 {
                bjStats.insurancePayouts += 1
            }
        }
        if outcome.betOnBust {
            balance += outcome.bustBetPayout
            bjStats.betOnBust += 1
            if outcome.bustBetPayout > 0 {
                bjStats.bustBetsWon += 1
            }
        }
        if outcome.hadBlackJack {
            bjStats.hadBlackJack += 1
        }
        if outcome.hadTripleSeven {
            bjStats.hadTripleSeven += 1
        }
        if outcome.bankHadBlackJack {
            bjStats.bankHadBlackJack += 1
            if outcome.winOrLose == Status.lost {
                bjStats.bankWonWithBlackJack += 1
            }
        }
        
        if outcome.doubledDown {
            bjStats.doubledDown += 1
        }
        if outcome.bankWentBust {
            bjStats.bankWentBust += 1
        }
    }
    func endRoulette(outcome: RouletteGameOver) {
        let winOrLose: Int
        if outcome.outcome {
            rouStats.gamesWon += 1
            balance += outcome.prize
            winOrLose = 0
        }
        else {
            rouStats.gamesLost += 1
            winOrLose = 1
        }
        rouStats.winsAndLosses.append(outcome.prize)
        rouStats.allStakes.append(outcome.stakes)
        if outcome.bet is OutsideBet {
            rouStats.numberOfOutsideGames += 1
            let outside = outcome.bet as! OutsideBet
            if outcome.outcome {
                rouStats.wonOutside += 1
            }
            switch outside.type {
            case .black: rouStats.black[winOrLose] += 1
            case .red: rouStats.red[winOrLose] += 1
            case .low: rouStats.low[winOrLose] += 1
            case .high: rouStats.high[winOrLose] += 1
            case .even: rouStats.even[winOrLose] += 1
            case .odd: rouStats.odd[winOrLose] += 1
            }
        }
        else if outcome.bet is InsideBet {
            rouStats.numberOfInsideGames += 1
            let inside = outcome.bet as! InsideBet
            if outcome.outcome {
                rouStats.wonInside += 1
            }
            switch inside.type {
            case .straightUp: rouStats.straightUp[winOrLose] += 1
            case .split: rouStats.split[winOrLose] += 1
            case .column: rouStats.column[winOrLose] += 1
            case .corner: rouStats.corner[winOrLose] += 1
            case .street: rouStats.street[winOrLose] += 1
            case .sixLine: rouStats.sixLine[winOrLose] += 1
            case .dozen: rouStats.dozen[winOrLose] += 1
            case .firstThree: rouStats.firstThree[winOrLose] += 1
            case .firstFour: rouStats.firstFour[winOrLose] += 1
            }
        }
    }
}

protocol Stats : Codable {
    var gamesWon: Int { get set }
    var gamesLost: Int { get set}
    var winsAndLosses: [Float] { get set }
    var allStakes: [Float] { get set }
}

class BlackJackStats : Stats, Codable {
    var gamesWon: Int
    var gamesLost: Int
    var winsAndLosses: [Float]
    var allStakes: [Float]
    var gamesTied: Int
    var hadBlackJack: Int
    var hadTripleSeven: Int
    var wonWithBlackJack: Int
    var bankHadBlackJack: Int
    var bankWonWithBlackJack: Int
    var insurances: [Float]
    var insurancePayouts: Int
    var tookInsurance: Int
    var bustBets: [Float]
    var bustBetsWon: Int
    var betOnBust: Int
    var doubledDown: Int
    var bankWentBust: Int
    
    init() {
        gamesWon = 0
        gamesLost = 0
        winsAndLosses = [Float]()
        allStakes = [Float]()
        gamesTied = 0
        hadBlackJack = 0
        hadTripleSeven = 0
        wonWithBlackJack = 0
        bankHadBlackJack = 0
        bankWonWithBlackJack = 0
        insurances = [Float]()
        insurancePayouts = 0
        bustBets = [Float]()
        bustBetsWon = 0
        doubledDown = 0
        bankWentBust = 0
        tookInsurance = 0
        betOnBust = 0
    }
    init(standard: Int) {
        gamesWon = standard
        gamesLost = standard
        winsAndLosses = [Float(standard)]
        allStakes = [Float(standard)]
        gamesTied = standard
        hadBlackJack = standard
        hadTripleSeven = standard
        wonWithBlackJack = standard
        bankHadBlackJack = standard
        bankWonWithBlackJack = standard
        insurances = [Float(standard)]
        insurancePayouts = standard
        bustBets = [Float(standard)]
        bustBetsWon = standard
        doubledDown = standard
        bankWentBust = standard
        tookInsurance = standard
        betOnBust = standard
    }
    
    enum CodingKeys: String, CodingKey {
        case gamesWon = "GamesWon"
        case gamesLost = "GamesLost"
        case winsAndLosses = "WinsAndLosses"
        case allStakes = "AllStakes"
        case gamesTied = "GamesTied"
        case hadBlackJack = "HadBlackJack"
        case hadTripleSeven = "HadTripleSeven"
        case wonWithBlackJack = "WonWithBlackJack"
        case bankHadBlackJack = "BankHadBlackJack"
        case bankWonWithBlackJack = "BankWonWithBlackJack"
        case insurances = "Insurances"
        case insurancePayouts = "InsurancePayouts"
        case tookInsurance = "TookInsurance"
        case bustBets = "BustBets"
        case bustBetsWon = "BustBetsWon"
        case betOnBust = "BetOnBust"
        case doubledDown = "DoubledDown"
        case bankWentBust = "BankWentBust"
    }
    
}
struct AbsoluteAndPercent {
    let name: String
    let absolute: Int
    let percent: Float
    let absoluteString: String
    let percentString: String
    init() {
        self.name = "Placeholder"
        self.absolute = 0
        self.percent = 0.0
        self.percentString = "\(MathHelper.roundFloat(number: percent)) %"
        self.absoluteString = "\(absolute)"
        //print("Default-Init Absolute and Percent")
    }
    init(_ name: String,_ absolute: Int,_ percent: Float) {
        self.name = name
        self.absolute = absolute
        self.percent = percent
        self.percentString = "\(MathHelper.roundFloat(number: percent)) %"
        self.absoluteString = "\(absolute)"
    }
}
struct RouletteAbsoluteAndPercent {
    let name: String
    let won: Int
    let lost: Int
    let percent: Float
    let wonString: String
    let lostString: String
    let percentString: String
    init(name: String,won: Int, lost: Int) {
        self.name = name
        self.won = won
        self.lost = lost
        if (self.won+self.lost) == 0 {
            self.percent = 0
        }
        else {
            self.percent = MathHelper.roundFloat(number: Float(self.won/(self.won+self.lost)*100))
        }
        
        self.wonString = "won: \(won)"
        self.lostString = "lost: \(lost)"
        self.percentString = "\(percent) %"
    }
}
struct MetaData {
    let name: String
    let number: Float
    let numberString: String
    
    init(text: String,_ no:Float) {
        self.name = text
        self.number = no
        self.numberString = "\(no) $"
    }
}

class RouletteStats : Stats {
    var numberOfOutsideGames: Int
    var numberOfInsideGames: Int
    var wonOutside: Int
    var wonInside: Int
    var even: [Int]
    var odd: [Int]
    var low: [Int]
    var high: [Int]
    var red: [Int]
    var black: [Int]
    var straightUp: [Int]
    var split: [Int]
    var corner: [Int]
    var firstThree: [Int]
    var firstFour: [Int]
    var column: [Int]
    var dozen: [Int]
    var sixLine: [Int]
    var street: [Int]
    override init() {
        numberOfInsideGames = 0
        numberOfOutsideGames = 0
        wonInside = 0
        wonOutside = 0
        even = [0,0]
        odd = [0,0]
        black = [0,0]
        red = [0,0]
        low = [0,0]
        high = [0,0]
        straightUp = [0,0]
        split = [0,0]
        corner = [0,0]
        firstThree = [0,0]
        firstFour = [0,0]
        column = [0,0]
        dozen = [0,0]
        sixLine = [0,0]
        street = [0,0]
        super.init()
    }
    init(statData: [String:[Int]], winAndLose: [Float], stakes: [Float]) {
        numberOfInsideGames = statData["number of inside games"]![0]
        numberOfOutsideGames = statData["number of outside games"]![0]
        wonOutside = statData["won outside"]![0]
        wonInside = statData["won inside"]![0]
        even = statData["even"]!
        odd = statData["odd"]!
        low = statData["low"]!
        high = statData["high"]!
        red = statData["red"]!
        black = statData["black"]!
        straightUp = statData["straight up"]!
        split = statData["split"]!
        corner = statData["corner"]!
        firstThree = statData["first three"]!
        firstFour = statData["first four"]!
        column = statData["column"]!
        dozen = statData["dozen"]!
        sixLine = statData["sixLine"]!
        street = statData["street"]!
        super.init(won: statData["games won"]![0], lost: statData["games lost"]![0], winAndLose: winAndLose, stakes: stakes)
    }
    
    func rouletteStatToDictionary() -> [String: [Int]] {
        let dic = ["games won": [gamesWon], "games lost":[gamesLost], "number of inside games": [numberOfInsideGames], "number of outside games": [numberOfOutsideGames], "won outside": [wonOutside], "won inside": [wonInside], "even": even, "odd": odd, "low": low, "high":high, "red": red, "black": black, "straight up": straightUp, "split": split, "corner": corner, "first three": firstThree, "first four": firstFour, "column": column, "dozen": dozen, "sixLine": sixLine, "street": street ]
        return dic
    }
    
}
