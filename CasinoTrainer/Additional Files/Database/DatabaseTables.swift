//
//  DatabaseTables.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

enum TableNames : String {
    case Guest, BlackJackGames, RouletteGames, BlackJackBustBet, BlackJackInsurance
}

protocol SQLTable {
    static var createStatement: String { get }
}

struct CasinoGuest {
    let id: Int32
    let name: NSString
    let capital: Double
    let balance: Double
    
    init(id: Int32, name: NSString, capital: Double, balance: Double) {
        self.id = id
        self.name = name
        self.capital = capital
        self.balance = balance
    }
    func description() -> String {
        return """
        Casino Guest:
            id: \(id)
            name: \(name)
            capital: \(capital)
            balance: \(balance)
        """
    }
}
extension CasinoGuest : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS \(TableNames.Guest.rawValue) (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name VARCHAR2(255) NOT NULL UNIQUE,
        Capital DOUBLE NOT NULL,
        Balance DOUBLE NOT NULL
        );
        """
    }
    
    
}
class BlackJackGame {
    let id: Int32
    let gameNo: Int32
    let status: Int32
    let hadBlackJack: Bool
    let bust: Bool
    let bankWentBust: Bool
    let bankHadBlackJack: Bool
    let stakes: Double
    let prize: Double
    let points: Int32
    let bankPoints: Int32
    let betOnBust: Bool
    let tookInsurance: Bool
    let doubledDown: Bool
    
    init(id: Int32, gameNo: Int32, status: Int32, hadBlackJack: Bool, bust: Bool, bankWentBust: Bool, bankHadBlackJack: Bool, stakes: Double, prize: Double, points: Int32, bankPoints: Int32, betOnBust: Bool, tookInsurance: Bool, doubledDown: Bool) {
        self.id = id
        self.gameNo = gameNo
        self.status = status
        self.hadBlackJack = hadBlackJack
        self.bust = bust
        self.bankWentBust = bankWentBust
        self.bankHadBlackJack = bankHadBlackJack
        self.stakes = stakes
        self.prize = prize
        self.points = points
        self.bankPoints = bankPoints
        self.betOnBust = betOnBust
        self.tookInsurance = tookInsurance
        self.doubledDown = doubledDown
    }
}
extension BlackJackGame : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS \(TableNames.BlackJackGames.rawValue) (
        Id INTEGER NOT NULL,
        GameNo INTEGER PRIMARY KEY AUTOINCREMENT,
        Status Int NOT NULL,
        Had_Blackjack Int NOT NULL,
        Won_with_Blackjack Int NOT NULL,
        Had_Triple_Seven Int NOT NULL,
        Bust Int NOT NULL,
        Bank_went_bust Int NOT NULL,
        Bank_had_Blackjack Int NOT NULL,
        Stakes DOUBLE NOT NULL,
        Prize DOUBLE NOT NULL,
        Points INT NOT NULL,
        Bank_Points INT NOT NULL,
        Bet_on_Bust Int NOT NULL,
        Took_Insurance Int NOT NULL,
        Doubled_down Int NOT NULL,
        FOREIGN KEY (Id) REFERENCES \(TableNames.Guest.rawValue) (Id)
        );
        """
    }
}
class BlackJackBustBet {
    let id: Int32
    let gameNo: Int32
    let stake: Double
    let payout: Double?
    
    init(id: Int32, no: Int32, stake: Double, payout: Double?) {
        self.id = id
        self.gameNo = no
        self.stake = stake
        self.payout = payout
    }
}
extension BlackJackBustBet : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS \(TableNames.BlackJackBustBet.rawValue) (
        Id INT NOT NULL,
        GameNo INT NOT NULL,
        Stake DOUBLE NOT NULL,
        Payout DOUBLE,
        PRIMARY KEY (Id, GameNo),
        FOREIGN KEY (Id) REFERENCES \(TableNames.Guest.rawValue) (Id)
        FOREIGN KEY (GameNo) REFERENCES \(TableNames.BlackJackGames.rawValue) (GameNo)
        );
        """
    }
}
class BlackJackInsurance {
    let id: Int32
    let gameNo: Int32
    let stake: Double
    let payout: Double?
    init(id: Int32, no: Int32, stake: Double, payout: Double?) {
        self.id = id
        self.gameNo = no
        self.stake = stake
        self.payout = payout
    }
}
extension BlackJackInsurance : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS \(TableNames.BlackJackInsurance.rawValue) (
        Id INT NOT NULL,
        GameNo INT NOT NULL,
        Stake DOUBLE NOT NULL,
        Payout DOUBLE,
        PRIMARY KEY (Id, GameNo),
        FOREIGN KEY (Id) REFERENCES \(TableNames.Guest.rawValue) (Id)
        FOREIGN KEY (GameNo) REFERENCES \(TableNames.BlackJackGames.rawValue) (GameNo)
        );
        """
    }
}
class RouletteGame {
    let id: Int32
    let gameNo: Int32
    let insideOutside: String
    let betType: String
    let stake: Double
    let payout: Double?
    let won: Bool
    
    init(id: Int32, no: Int32, insideOutside: String, bettype: String, stake: Double, payout: Double?, won: Bool) {
        self.id = id
        self.gameNo = no
        self.insideOutside = insideOutside
        self.betType = bettype
        self.stake = stake
        self.payout = payout
        self.won = won
    }
}
extension RouletteGame : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS \(TableNames.RouletteGames.rawValue) (
        Id INT NOT NULL,
        GameNo INTEGER PRIMARY KEY AUTOINCREMENT,
        Inside_or_Outside VARCHAR2(8) NOT NULL,
        Bet_type VARCHAR2(20) NOT NULL,
        Stake DOUBLE NOT NULL,
        Payout DOUBLE,
        Won INT NOT NULL,
        FOREIGN KEY (Id) REFERENCES \(TableNames.Guest.rawValue) (Id)
        );
        """
    }
}
