//
//  DatabaseController.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 04.06.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseController {
    var db: SQLiteDatabase
    
    init() {
        do {
            try db = SQLiteDatabase.open(path: Database.CasinoTrainer.path)
        }
        catch {
            print("An error occurred loading the Database")
            db = SQLiteDatabase(dbPointer: nil)
        }
        do
        {
            try db.createTable(table: CasinoGuest.self)
            try db.createTable(table: BlackJackGame.self)
            try db.createTable(table: BlackJackBustBet.self)
            try db.createTable(table: BlackJackInsurance.self)
            try db.createTable(table: RouletteGame.self)
        }
        catch {
            print(db.errorMessage)
        }
    }
    init(pointer: OpaquePointer?) {
        db = SQLiteDatabase(dbPointer: pointer)
    }
    func getPlayer(name: String) -> CasinoGuest? {
        do {
            return try db.getPlayer(name: name)
        }
        catch {
            print(db.errorMessage)
            return nil
        }
    }
    func insertPlayer(_ name: String, capital: Float) -> Int? {
        do {
            return try db.insertPlayer(name, capital: capital)
        }
        catch {
            print(db.errorMessage)
            return nil
        }
    }
    func updateBalance(player: Player) {
        do {
            try db.updateBalance(player: player)
        }
        catch {
            print(db.errorMessage)
        }
    }
    func insertBlackJackGameRow(_ result: BlackJackGameOver, player: Player)  {
        do {
            try db.insertBlackJackGameRow(result, player: player)
        }
        catch {
            print(db.errorMessage)
        }
    }
    func getPointer() -> OpaquePointer? {
        return db.dbPointer
    }
}
