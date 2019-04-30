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
    func insertPlayer(_ player: String) throws {
        let insertPlayerSQL = "INSERT INTO \(TableNames.Guest.rawValue) (Name) VALUES (?);"
        let insertStatement = try prepareStatement(sql: insertPlayerSQL)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let playerName: NSString = player as NSString
        guard sqlite3_bind_text(insertStatement, 2, playerName.utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row")
    }
}
//extension SQLiteDatabase {
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
//}
