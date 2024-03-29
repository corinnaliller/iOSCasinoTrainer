//
//  Database.swift
//  CasinoTrainer
//
//  Created by Corinna Liller on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation
import SQLite3

/// Die Datenbank
/// Es gibt leider ein paar Probleme. Die Daten werden zwar in die Datenbank
/// eingetragen, aber das Abrufen funktioniert nicht wie es soll.
/// Auf der Seite https://sqlitebrowser.org kann man sich einen Browser für
/// die Daten holen, damit man sich diese ansehen kann.
/// Außerdem gibt es Probleme mit dem Pointer. Die VCs geben den Pointer für
/// die Datenbank untereinander weiter sodass immer auf die gleiche DB verwiesen wird
/// und nicht ständig eine neue geöffnet. Allerdings kommt trotzdem immer wieder
/// eine Fehlermeldung, der Pointer sei "invalid".
class SQLiteDatabase {
    let dbPointer: OpaquePointer?
    
    init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
        print("Database-Pointer: \(dbPointer)")
        print(Database.CasinoTrainer.path)
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    var errorMessage: String {
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
        print("Opening database")
        
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

    func close() {
        sqlite3_close(dbPointer)
    }
}

/// CREATE AND INSERT
extension SQLiteDatabase {
    func dropTable(table: SQLTable.Type) throws {
        let dropTableStatement = try prepareStatement(sql: table.dropStatement)
        defer {
            sqlite3_finalize(dropTableStatement)
        }
        guard sqlite3_step(dropTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table dropped")
    }
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
    // Neuen Spieler anlegen
    func insertPlayer(_ player: String, capital: Float) throws -> Int {
        let insertPlayerSQL = "INSERT INTO \(TableNames.Guest.rawValue) (Name, Capital, Balance) VALUES (?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertPlayerSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let playerName: NSString = player as NSString
        guard sqlite3_bind_text(insertStatement, 1, playerName.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_double(insertStatement, 2, Double(capital)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 3, Double(capital)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted \(player)")
        let id = sqlite3_last_insert_rowid(insertStatement)
        
        return Int(id)
    }
    // Blackjack-Spiel speichern
    func insertBlackJackGameRow(_ game: BlackJackGameOver, player: Player) throws {
        let insertBlackJackSQL = "INSERT INTO \(TableNames.BlackJackGames.rawValue) (Id, Status, Had_Blackjack, Bust, Bank_went_bust, Bank_had_Blackjack, Stakes, Prize, Points, Bank_Points, Bet_on_Bust, Took_Insurance, Doubled_down, Won_with_Blackjack, Had_Triple_Seven) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        print("Inserting for player with id: \(player.id)")
        print("Inserting for player with id: \(Int32(player.id))")
        let insertStatement = try prepareStatement(sql: insertBlackJackSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard sqlite3_bind_int(insertStatement, 1, Int32(player.id)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 2, Int32(game.winOrLose.rawValue)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, boolToInt(test: game.hadBlackJack)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 4, boolToInt(test: game.wentBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, boolToInt(test: game.bankWentBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 6, boolToInt(test: game.bankHadBlackJack)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 7, Double(game.stakesMoney)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 8, Double(game.prizeMoney)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 9, Int32(game.points)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 10, Int32(game.bankPoints)) == SQLITE_OK &&  sqlite3_bind_int(insertStatement, 11, boolToInt(test: game.betOnBust)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 12, boolToInt(test: game.tookInsurance)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 13, boolToInt(test: game.doubledDown)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 14, boolToInt(test: (game.winOrLose.rawValue == 3))) == SQLITE_OK && sqlite3_bind_int(insertStatement, 15, boolToInt(test: game.hadTripleSeven)) == SQLITE_OK else {
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
    // Bust-Wette speichern
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
    // Blackjack-Versicherung speichern
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
    // Roulette-Spiel speichern
    func insertRouletteGameRow(_ game: RouletteGameOver, player: Player) throws {
        let insertRouletteSQL = "INSERT INTO \(TableNames.RouletteGames.rawValue) (Id, Inside_or_Outside, Bet_type, Stake, Payout, won) VALUES (?, ?, ?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertRouletteSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let insideOutside: String
        let betType: String
        if let b = game.bet as? InsideBet {
            insideOutside = "Inside"
            betType = b.type.rawValue
        }
        else {
            let b = game.bet as! OutsideBet
            insideOutside = "Outside"
            betType = b.type.rawValue
        }
        guard sqlite3_bind_int(insertStatement, 1, Int32(player.id)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, insideOutside, -1, nil) == SQLITE_OK && sqlite3_bind_text(insertStatement, 3, betType, -1, nil) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, Double(game.stakes)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 5, Double(game.prize)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 6, boolToInt(test: game.outcome)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted Roulette row")
    }
    // Helfer-Funktion zur Umwandlung von Bool zu Int
    func boolToInt(test: Bool) -> Int32 {
        if test {
            return 1
        }
        else {
            return 0
        }
    }
}

/// SELECT
// Hier werden die Ergebnisse wieder aus der Datenbank geholt.
// In der Theorie zumindest...
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
    // Diese Funktion sollte die Ergebnisse für die Blackjack-Statistik-Tabelle
    // liefern. Leider funktioniert es nicht wie es soll und da es etwas
    // schwierig ist, nachzuvollziehen, was wo geschieht, ist es nicht leicht,
    // den Fehler zu beheben...
    func getBlackJackStatistics(player: Player) throws -> GeneralBlackJackStatistics? {
        let generalStat = try getWinLossCounts(id: player.id)
        let insurancesPaidOut = try insurancePayouts(id: player.id)
        let bustBetsPaidOut = try bustBetPayouts(id: player.id)
        let wonDoubleDown = gamesWonAfterDoubleDown(player: player)
        let querySql = "SELECT sum(had_blackjack), sum(had_triple_seven), sum(bust), sum(bank_had_blackjack), count(bi.gameNo), sum(bank_went_bust), count(bb.gameNo), sum(doubled_down) FROM (\(TableNames.BlackJackGames.rawValue) bg JOIN \(TableNames.BlackJackBustBet.rawValue) bb ON bg.GameNo = bb.GameNo) JOIN \(TableNames.BlackJackInsurance.rawValue) bi ON bg.GameNo = bi.GameNo WHERE bg.Id = ?;"
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
        var playerStat = [Int]()
        var bankStat = [Int]()
        var extraStat = [Int]()
        playerStat.append(Int(sqlite3_column_int(queryStatement, 0)))
        playerStat.append(Int(generalStat[3] ?? 0))
        playerStat.append(Int(sqlite3_column_int(queryStatement, 1)))
        playerStat.append(Int(sqlite3_column_int(queryStatement, 2)))
        bankStat.append(Int(sqlite3_column_int(queryStatement, 3)))
        bankStat.append(Int(sqlite3_column_int(queryStatement, 4)))
        bankStat.append(insurancesPaidOut)
        bankStat.append(Int(sqlite3_column_int(queryStatement, 5)))
        bankStat.append(Int(sqlite3_column_int(queryStatement, 6)))
        bankStat.append(bustBetsPaidOut)
        extraStat.append(Int(sqlite3_column_int(queryStatement, 7)))
        extraStat.append(wonDoubleDown)
        return GeneralBlackJackStatistics(general: generalStat as! [Int], player: playerStat, bank: bankStat, extra: extraStat)
    }
    // Spieler aus der Datenbank holen.
    // Funktioniert einwandfrei.
    func getPlayer(name: String) throws -> CasinoGuest? {
        let querySql = "SELECT * FROM \(TableNames.Guest.rawValue) WHERE Name = ?;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_text(queryStatement, 1, name, -1, nil) == SQLITE_OK else {
            return nil
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
        let playerID = sqlite3_column_int(queryStatement, 0)
        let playerName = String(cString: sqlite3_column_text(queryStatement, 1)) as NSString
        let playerCapital = sqlite3_column_double(queryStatement, 2)
        let playerBalance = sqlite3_column_double(queryStatement, 3)
        print("Retrieving \(playerName), ID: \(playerID), Capital: \(playerCapital), Balance: \(playerBalance)")
        return CasinoGuest(id: playerID, name: playerName, capital: playerCapital, balance: playerBalance)
    }
    private func getWinLossCounts(id: Int) throws -> [Int?] {
        var outcomes = [[Int]]()
        let querySql = "SELECT status,count(*) FROM \(TableNames.BlackJackGames.rawValue) WHERE Id = ? GROUP BY status;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return [Int]()
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(id)) == SQLITE_OK else {
            return [Int]()
        }
        while (sqlite3_step(queryStatement) == SQLITE_ROW)  {
            outcomes.append([Int(sqlite3_column_int(queryStatement, 0)), Int(sqlite3_column_int(queryStatement, 1))])
        }
        return fillOutcomes(outcomes: outcomes)
    }
    private func fillOutcomes(outcomes: [[Int]]) -> [Int] {
        var result = Array(repeating: 0, count: 4)
        for i in 0..<outcomes.count {
            if outcomes[i][0] == i {
                result[i] = outcomes[i][1]
            }
        }
        return result
    }
    private func insurancePayouts(id: Int) throws -> Int {
        let querySql = "SELECT count(*) FROM \(TableNames.BlackJackInsurance.rawValue) WHERE id = ? AND payout > 0;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return 0
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(id)) == SQLITE_OK else {
            return 0
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return 0
        }
        let insurances = Int(sqlite3_column_int(queryStatement, 0))
        
        return insurances
    }
    private func bustBetPayouts(id: Int) throws -> Int {
        let querySql = "SELECT count(*) FROM \(TableNames.BlackJackBustBet.rawValue) WHERE id = ? AND payout > 0;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return 0
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, Int32(id)) == SQLITE_OK else {
            return 0
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return 0
        }
        let bustBets = Int(sqlite3_column_int(queryStatement, 0))
        
        return bustBets
    }
    // Alle eingetragenen Spieler aus der Datenbank holen.
    // Ist notwendig, um festzustellen, ob ein neuer Spielername schon
    // besetzt ist. Oder um sich unter einem vorhandenen Namen einzuloggen.
    // Funktioniert - soweit ich weiß...
    func getAllPlayerNames() throws -> [String]? {
        let querySql = "SELECT Name FROM \(TableNames.Guest.rawValue);"
        var playerNames = [String]()
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        while (sqlite3_step(queryStatement) == SQLITE_ROW)  {
            playerNames.append(String(cString:sqlite3_column_text(queryStatement, 0)))
        }
//        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
//            return nil
//        }
        return playerNames
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

/// UPDATE
extension SQLiteDatabase {
    // Kontostand des Spielers anpassen. Funktioniert.
    func updateBalance(player: Player) throws {
        let updateSQL = "UPDATE \(TableNames.Guest.rawValue) SET Balance = ? WHERE Id = ?"
        guard let updateStatement = try? prepareStatement(sql: updateSQL) else {
            throw SQLiteError.Prepare(message: "Could not prepare statement for update of balance")
        }
        defer {
            sqlite3_finalize(updateStatement)
        }
        guard sqlite3_bind_double(updateStatement, 1, Double(player.balance)) == SQLITE_OK && sqlite3_bind_int(updateStatement, 2, Int32(player.id)) == SQLITE_OK else {
            throw SQLiteError.Bind(message: "Could not bind data for balance")
        }
        guard sqlite3_step(updateStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: "Could not update balance")
        }
    }
}
