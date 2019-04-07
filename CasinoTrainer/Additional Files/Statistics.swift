//
//  Statistics.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 18.11.18.
//  Copyright © 2018 Corinna Liller. All rights reserved.
//

import Foundation
import UIKit

class Player : Codable {
    
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
    enum CodingKeys : String, CodingKey {
        case playerName = "PlayerName"
        case initialCapital = "InitialCapital"
        case balance = "Balance"
        case bjStats = "BlackjackStats"
        case rouStats = "RouletteStats"
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
        if outcome.outcome {
            rouStats.gamesWon += 1
            balance += outcome.prize
        }
        else {
            rouStats.gamesLost += 1
        }
        rouStats.winsAndLosses.append(outcome.prize)
        rouStats.allStakes.append(outcome.stakes)
        if let outside = outcome.bet as? OutsideBet {
            rouStats.numberOfOutsideGames += 1
            if outcome.outcome {
                rouStats.wonOutside += 1
                rouStats.outsideOutcomes[outside.type]![0] += 1
            }
            else {
                rouStats.outsideOutcomes[outside.type]![1] += 1
            }
        }
        else if let inside = outcome.bet as? InsideBet {
            rouStats.numberOfInsideGames += 1
            if outcome.outcome {
                rouStats.wonInside += 1
                rouStats.insideOutcomes[inside.type]![0] += 1
            }
            else {
                rouStats.insideOutcomes[inside.type]![1] += 1
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
class WinAndLose : Codable {
    var win: Int
    var lose: Int
    init() {
        win = 0
        lose = 0
    }
    enum CodingKeys: String, CodingKey {
        case win = "win"
        case lose = "lose"
    }
}

class RouletteStats : Stats {
    var gamesWon: Int
    var gamesLost: Int
    var winsAndLosses: [Float]
    var allStakes: [Float]
    var numberOfOutsideGames: Int
    var numberOfInsideGames: Int
    var wonOutside: Int
    var wonInside: Int
    var insideOutcomes: [Inside: [Int]]
    var outsideOutcomes: [Outside: [Int]]
    
    init() {
        gamesWon = 0
        gamesLost = 0
        winsAndLosses = [Float]()
        allStakes = [Float]()
        numberOfInsideGames = 0
        numberOfOutsideGames = 0
        wonInside = 0
        wonOutside = 0
        insideOutcomes = [
            Inside.straightUp: [0,0],
            Inside.column: [0,0],
            Inside.dozen: [0,0],
            Inside.corner: [0,0],
            Inside.split: [0,0],
            Inside.firstFour: [0,0],
            Inside.firstThree: [0,0],
            Inside.street: [0,0],
            Inside.sixLine:[0,0]
        ]
        outsideOutcomes = [
            Outside.red: [0,0],
            Outside.black: [0,0],
            Outside.low: [0,0],
            Outside.high: [0,0],
            Outside.even: [0,0],
            Outside.odd: [0,0]
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case gamesWon = "GamesWon"
        case gamesLost = "GamesLost"
        case winsAndLosses = "WinsAndLosses"
        case allStakes = "AllStakes"
        case numberOfOutsideGames = "NumberOfOutsideGames"
        case numberOfInsideGames = "NumberOfInsideGames"
        case wonOutside = "WonOutside"
        case wonInside = "WonInside"
        case insideOutcomes = "InsideOutcomes"
        case outsideOutcomes = "OutsideOutcomes"
    }
}
