//
//  DataSaver.swift
//  CasinoTrainer
//
//  Created by Corinna Liller / BBM2H17M on 13.02.19.
//  Copyright © 2019 Corinna Liller. All rights reserved.
//

import Foundation
enum SavingKeys : String {
    case player = "CasinoGuest"
}
enum CasinoError : Error {
    case guestNotFound
    case guestLoading
    case guestSavingError
}

class DataSaver {
    
    static func saveGuest(guest: Player) throws {
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(guest) {
            defaults.set(encoded, forKey: SavingKeys.player.rawValue)
        }
        else {
            throw CasinoError.guestSavingError
        }
        defaults.synchronize()
    }
    static func retrieveGuest() throws -> Player {
        let defaults = UserDefaults.standard
        if let savedGuest = defaults.object(forKey: SavingKeys.player.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedGuest = try? decoder.decode(Player.self, from: savedGuest) {
                return loadedGuest
            }
            else {
                throw CasinoError.guestLoading
            }
        }
        else {
            throw CasinoError.guestNotFound
        }
    }
}
