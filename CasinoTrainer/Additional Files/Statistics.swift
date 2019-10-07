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
    
    let id: Int
    var playerName: String
    var initialCapital: Float
    var balance: Float
//    var bjStats: BlackJackStats
//    var rouStats: RouletteStats
    init() {
        id = 0
        playerName = "Placeholder"
        balance = 10
        initialCapital = 20
//        bjStats = BlackJackStats()
//        rouStats = RouletteStats()
    }
    init(guest: CasinoGuest) {
        self.id = Int(guest.id)
        self.playerName = String(guest.name)
        self.balance = Float(guest.balance)
        self.initialCapital = Float(guest.capital)
    }
    init(id: Int, name: String, capital: Float) {
        self.id = id
        playerName = name
        initialCapital = capital
        balance = initialCapital
//        bjStats = BlackJackStats()
//        rouStats = RouletteStats()
    }
    enum CodingKeys : String, CodingKey {
        case id = "ID"
        case playerName = "PlayerName"
        case initialCapital = "InitialCapital"
        case balance = "Balance"
//        case bjStats = "BlackjackStats"
//        case rouStats = "RouletteStats"
    }
    func description() -> String {
        return """
        ID: \(id)
        name: \(playerName)
        initial capital: \(initialCapital)
        balance: \(balance)
        """
    }
    
//    func endBlackJack(outcome: BlackJackGameOver) {
//        switch outcome.winOrLose {
//        case .lost:
//            bjStats.gamesLost += 1
//            bjStats.winsAndLosses.append(-outcome.stakesMoney)
//        case .tie:
//            bjStats.outcomes[BlackJackOutcomes.gamesTied]! += 1
//            bjStats.winsAndLosses.append(0)
//        case .won:
//            bjStats.gamesWon += 1
//            bjStats.winsAndLosses.append(outcome.prizeMoney)
//        case .bjwon:
//            bjStats.gamesWon += 1
//            bjStats.outcomes[BlackJackOutcomes.wonWithBlackJack]! += 1
//            bjStats.winsAndLosses.append(outcome.prizeMoney)
//        }
//        balance += outcome.prizeMoney + outcome.insurancePayout + outcome.bustBetPayout
//        bjStats.allStakes.append(outcome.stakesMoney)
//        bjStats.bustBets.append(outcome.bustBetPayout)
//        if outcome.tookInsurance {
//            balance += outcome.insurancePayout
//            bjStats.outcomes[BlackJackOutcomes.tookInsurance]! += 1
//            if outcome.insurancePayout > 0 {
//                bjStats.outcomes[BlackJackOutcomes.insuranceWasPaidOut]! += 1
//            }
//        }
//        if outcome.betOnBust {
//            balance += outcome.bustBetPayout
//            bjStats.outcomes[BlackJackOutcomes.betOnBust]! += 1
//            if outcome.bustBetPayout > 0 {
//                bjStats.outcomes[BlackJackOutcomes.bankWentBust]! += 1
//            }
//        }
//        if outcome.hadBlackJack {
//            bjStats.outcomes[BlackJackOutcomes.hadBlackJack]! += 1
//        }
//        if outcome.hadTripleSeven {
//            bjStats.outcomes[BlackJackOutcomes.hadTripleSeven]! += 1
//        }
//        if outcome.bankHadBlackJack {
//            bjStats.outcomes[BlackJackOutcomes.bankHadBlackJack]! += 1
//            if outcome.winOrLose == Status.lost {
//                bjStats.outcomes[BlackJackOutcomes.bankWonWithBlackJack]! += 1
//            }
//        }
//        if outcome.wentBust {
//            bjStats.outcomes[BlackJackOutcomes.playerWentBust]! += 1
//        }
//        if outcome.doubledDown {
//            bjStats.outcomes[BlackJackOutcomes.doubledDown]! += 1
//        }
//        if outcome.bankWentBust {
//            bjStats.outcomes[BlackJackOutcomes.bankWentBust]! += 1
//        }
//    }
//    func endRoulette(outcome: RouletteGameOver) {
//        if outcome.outcome {
//            rouStats.gamesWon += 1
//            balance += outcome.prize
//        }
//        else {
//            rouStats.gamesLost += 1
//        }
//        rouStats.winsAndLosses.append(outcome.prize)
//        rouStats.allStakes.append(outcome.stakes)
//        if let outside = outcome.bet as? OutsideBet {
//            rouStats.numberOfOutsideGames += 1
//            if outcome.outcome {
//                rouStats.wonOutside += 1
//                rouStats.outsideOutcomes[outside.type]![0] += 1
//            }
//            else {
//                rouStats.outsideOutcomes[outside.type]![1] += 1
//            }
//        }
//        else if let inside = outcome.bet as? InsideBet {
//            rouStats.numberOfInsideGames += 1
//            if outcome.outcome {
//                rouStats.wonInside += 1
//                rouStats.insideOutcomes[inside.type]![0] += 1
//            }
//            else {
//                rouStats.insideOutcomes[inside.type]![1] += 1
//            }
//        }
//    }
}

protocol Stats : Codable {
    var gamesWon: Int { get set }
    var gamesLost: Int { get set}
    var winsAndLosses: [Float] { get set }
    var allStakes: [Float] { get set }
}
enum BlackJackOutcomes : String, Codable {
    case gamesWon = "Games Won"
    case gamesTied = "Games Tied"
    case gamesLost = "Games Lost"
    case hadBlackJack = "Had Black Jack"
    case hadTripleSeven = "Had Triple Seven"
    case wonWithBlackJack = "Won With BlackJack"
    case bankHadBlackJack = "Bank Had BlackJack"
    case bankWonWithBlackJack = "Bank Won With BlackJack"
    case insuranceWasPaidOut = "Insurance Was Paid Out"
    case tookInsurance = "Took Insurance"
    case betOnBust = "Bet On Bust"
    case bustBetsWon = "Bust Bets Won"
    case doubledDown = "Doubled Down"
    case wonAfterDoubleDown = "Won After Doubleing Down"
    case bankWentBust = "Bank Went Bust"
    case playerWentBust = "Player Went Bust"
}

class BlackJackStats : Stats, Codable {
    var gamesWon: Int
    var gamesLost: Int
    var winsAndLosses: [Float]
    var allStakes: [Float]
    var outcomes: [BlackJackOutcomes: Int]
    var insurances: [Float]
    var bustBets: [Float]
    
    init() {
        gamesWon = 0
        gamesLost = 0
        winsAndLosses = [Float]()
        allStakes = [Float]()
        insurances = [Float]()
        bustBets = [Float]()
        outcomes = [
            BlackJackOutcomes.gamesTied: 0,
            BlackJackOutcomes.hadBlackJack: 0,
            BlackJackOutcomes.hadTripleSeven: 0,
            BlackJackOutcomes.wonWithBlackJack: 0,
            BlackJackOutcomes.bankHadBlackJack: 0,
            BlackJackOutcomes.bankWonWithBlackJack: 0,
            BlackJackOutcomes.insuranceWasPaidOut: 0,
            BlackJackOutcomes.tookInsurance: 0,
            BlackJackOutcomes.betOnBust: 0,
            BlackJackOutcomes.bustBetsWon: 0,
            BlackJackOutcomes.doubledDown: 0,
            BlackJackOutcomes.bankWentBust: 0,
            BlackJackOutcomes.playerWentBust: 0
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case gamesWon = "GamesWon"
        case gamesLost = "GamesLost"
        case winsAndLosses = "WinsAndLosses"
        case allStakes = "AllStakes"
        case outcomes = "GamesTied"
        case insurances = "Insurances"
        case bustBets = "BustBets"
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
