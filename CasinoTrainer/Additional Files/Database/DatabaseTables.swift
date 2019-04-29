//
//  DatabaseTables.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

enum TableNames : String {
    case Players, BlackJackGames, RouletteGames
}

protocol SQLTable {
    static var createStatement: String { get }
}

struct PlayerTable {
    let id: Int32
    let name: NSString
}
extension PlayerTable : SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE \(TableNames.Players.rawValue) (
        Id INT PRIMARY KEY AUTOINCREMENT,
        Name VARCHAR(255)
        );
        """
    }
    
    
}
