//
//  DatabaseHelpers.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 29.04.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
enum Database: String {
    case CasinoTrainer
    
    var path: String {
        return documentsDirectory.appendingPathComponent("\(self.rawValue).sqlite").relativePath
    }
}
let casinoDatabasePath = Database.CasinoTrainer.path

private func destroyDatabase(db: Database) {
    do {
        if FileManager.default.fileExists(atPath: db.path) {
            try FileManager.default.removeItem(atPath: db.path)
        }
    } catch {
        print("Could not destroy \(db) Database file.")
    }
}
enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}
