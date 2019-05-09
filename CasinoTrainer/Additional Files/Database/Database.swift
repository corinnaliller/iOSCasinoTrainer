//
//  Database.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase {
    fileprivate let dbPointer: OpaquePointer?
    
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        }
        else {
            return "No error message provided by sqlite"
        }
    }
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        }
        else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
        }
        if let errorPointer = sqlite3_errmsg(db) {
            let message = String(cString: errorPointer)
            throw SQLiteError.OpenDatabase(message: message)
        }
        else {
            throw SQLiteError.OpenDatabase(message: "No Error Message provided")
        }
    }
}
extension SQLiteDatabase {
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created")
    }
    func insertPlayer(_ player: String, capital: Float) throws {
        let insertPlayerSQL = "INSERT INTO \(TableNames.Guest.rawValue) VALUES (null, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertPlayerSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let playerName: NSString = player as NSString
        guard sqlite3_bind_text(insertStatement, 2, playerName.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_double(insertStatement, 3, Double(capital)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, Double(capital)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row")
    }
    func insertBlackJackGameRow(_ game: BlackJackGameOver, player: Player) throws {
        let insertBlackJackSQL = "INSERT INTO \(TableNames.BlackJackGames.rawValue) (Id, Status, Had_Blackjack, Bust, Bank_went_bust, Bank_had_Blackjack, Stakes, Prize, Points, Bank_Points, Bet_on_Bust, Took_Insurance, Doubled_down) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertBlackJackSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard sqlite3_bind_int(insertStatement, 1, Int32(player.id)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 2, Int32(game.winOrLose.rawValue)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, boolToInt(test: game.hadBlackJack)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 4, boolToInt(test: game.wentBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, boolToInt(test: game.bankWentBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 6, boolToInt(test: game.bankHadBlackJack)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 7, Double(game.stakesMoney)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 8, Double(game.prizeMoney)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 9, Int32(game.points)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 10, Int32(game.bankPoints)) == SQLITE_OK &&  sqlite3_bind_int(insertStatement, 11, boolToInt(test: game.betOnBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 12, boolToInt(test: game.tookInsurance)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 13, boolToInt(test: game.doubledDown)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        let gameNo = sqlite3_last_insert_rowid(insertStatement)
        if game.betOnBust {
            try? insertBlackJackBustBetRow(playerId: player.id, gameNo: Int32(gameNo), stake: Double(game.bustBetStakes), payout: Double(game.bustBetPayout))
        }
        if game.tookInsurance {
            try? insertBlackJackInsuranceRow(playerId: player.id, gameNo: Int32(gameNo), stake: Double(game.insurance), payout: Double(game.insurancePayout))
        }
        print("Successfully inserted Blackjack row")
    }
    private func insertBlackJackBustBetRow(playerId: Int, gameNo: Int32, stake: Double, payout: Double) throws {
        let insertBlackJackSQL = "INSERT INTO \(TableNames.BlackJackBustBet.rawValue) VALUES (?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertBlackJackSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard sqlite3_bind_int(insertStatement, 1, Int32(playerId)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 2, Int32(gameNo)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 3, stake) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, payout) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted bust bet row")
    }
    private func insertBlackJackInsuranceRow(playerId: Int, gameNo: Int32, stake: Double, payout: Double) throws {
        let insertBlackJackSQL = "INSERT INTO \(TableNames.BlackJackInsurance.rawValue) VALUES (?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertBlackJackSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard sqlite3_bind_int(insertStatement, 1, Int32(playerId)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 2, Int32(gameNo)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 3, stake) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, payout) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted insurance row")
    }
    func boolToInt(test: Bool) -> Int32 {
        if test {
            return 1
        }
        else {
            return 0
        }
    }
    func charToBool(char: String) -> Bool {
        if char == "y" {
            return true
        }
        else {
            return false
        }
    }
}
extension SQLiteDatabase {
    func gamesWonAfterDoubleDown(player: Player) -> Int {
        let querySql = "SELECT count(Doubled_down) FROM \(TableNames.BlackJackGames.rawValue) WHERE Id = ? AND Status = 2;"
                guard let queryStatement = try? prepareStatement(sql: querySql) else {
                    return 0
                }
                defer {
                    sqlite3_finalize(queryStatement)
                }
        guard sqlite3_bind_int(queryStatement, 1, Int32(player.id)) == SQLITE_OK else {
                    return 0
                }
                guard sqlite3_step(queryStatement) == SQLITE_ROW else {
                    return 0
                }
                let wonDD = sqlite3_column_int(queryStatement, 0)
                return Int(wonDD)
    }
    func getBlackJackStatistics(player: Player) -> GeneralBlackJackStatistics? {
        // Change here
        let querySql = "SELECT * FROM \(TableNames.BlackJackGames.rawValue) WHERE Id = ? AND Status = 2;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(player.id)) == SQLITE_OK else {
            return nil
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
        //let wonDD = sqlite3_column_int(queryStatement, 0)
        return nil
    }
    
//    func blackJackGame(id: Int32) -> BlackJackGame? {
//        let querySql = "SELECT * FROM \(TableNames.BlackJackGames.rawValue) WHERE Id = ?;"
//        guard let queryStatement = try? prepareStatement(sql: querySql) else {
//            return nil
//        }
//        defer {
//            sqlite3_finalize(queryStatement)
//        }
//        guard sqlite3_bind_int(queryStatement, 1, id) == SQLITE_OK else {
//            return nil
//        }
//        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
//            return nil
//        }
//        let id = sqlite3_column_int(queryStatement, 0)
//        let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
//        let name = String(cString: queryResultCol1!) as NSString
//        return Contact(id: id, name: name)
//    }
}
