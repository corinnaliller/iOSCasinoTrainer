//
//  DatabaseTables.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

enum TableNames : String {
    case Guest, BlackJackGames, RouletteGames
}

protocol SQLTable {
    static var createStatement: String { get }
}

struct CasinoGuest {
    let id: Int32
    let name: NSString
    
    init(id: Int32, name: NSString) {
        self.id = id
        self.name = name
    }
}
extension CasinoGuest : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE \(TableNames.Guest.rawValue) (
        Id INT PRIMARY KEY AUTOINCREMENT,
        Name VARCHAR(255) NOT NULL UNIQUE
        );
        """
    }
    
    
}
struct BlackJackGame {
    let id: Int32
    let gameNo: Int32
    let won: Bool
    let bust: Bool
    let bankWentBust: Bool
    let stakes: Float32
    let prize: Float32
    let points: Int32
    let bankPoints: Int32
    let betOnBust: Bool
    let bustBetStake: Float32?
    let bustBetPayout: Float32?
    let tookInsurance: Bool
    let insuranceStake: Float32?
    let insurancePayout: Float32?
    
    init(id: Int32, gameNo: Int32, won: Bool, bust: Bool, bankWentBust: Bool, stakes: Float32, prize: Float32, points: Int32, bankPoints: Int32, betOnBust: Bool, bustBetStake: Float32?, bustBetPayout: Float32?, tookInsurance: Bool, insuranceStake: Float32?, insurancePayout: Float32?) {
        self.id = id
        self.gameNo = gameNo
        self.won = won
        self.bust = bust
        self.bankWentBust = bankWentBust
        self.stakes = stakes
        self.prize = prize
        self.points = points
        self.bankPoints = bankPoints
        self.betOnBust = betOnBust
        self.bustBetStake = bustBetStake
        self.bustBetPayout = bustBetPayout
        self.tookInsurance = tookInsurance
        self.insuranceStake = insuranceStake
        self.insurancePayout = insurancePayout
    }
}
extension BlackJackGame : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE \(TableNames.BlackJackGames.rawValue) (
        Id INT NOT NULL,
        GameNo INT PRIMARY KEY AUTOINCREMENT,
        Won INT NOT NULL,
        Bust INT NOT NULL,
        Bank_went_bust INT NOT NULL,
        Stakes FLOAT NOT NULL,
        Prize FLOAT NOT NULL,
        Points INT NOT NULL,
        Bank_Points INT NOT NULL,
        Bet_on_Bust INT NOT NULL,
        BustBet_Stake FLOAT,
        BustBet_Payout FLOAT,
        Took_Insurance Int NOT NULL,
        Insurance_Stake FLOAT,
        Insurance_Payout FLOAT,
        FOREIGN KEY (Id) REFERENCES \(TableNames.Guest.rawValue) (Id)
        );
        """
    }
    
    
}
